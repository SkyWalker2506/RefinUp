-- RefinUp Supabase Schema
-- Date: 2026-04-08
-- Status: Draft — Sprint 1 Day 1 implementation
-- Jira: RFU-14
-- Ref: ADR-001 (Flutter + Supabase), ADR-002 (BFF architecture)

-- ============================================================
-- EXTENSIONS
-- ============================================================

create extension if not exists "uuid-ossp";

-- ============================================================
-- USERS
-- Extended from Supabase Auth (auth.users)
-- ============================================================

create table public.users (
  id            uuid primary key references auth.users(id) on delete cascade,
  email         text not null,
  display_name  text,
  avatar_url    text,
  tier          text not null default 'free'   -- free | pro | creator | team
                  check (tier in ('free', 'pro', 'creator', 'team')),
  trial_started_at  timestamptz,
  trial_ends_at     timestamptz,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- RLS
alter table public.users enable row level security;
create policy "Users can read own row"   on public.users for select using (auth.uid() = id);
create policy "Users can update own row" on public.users for update using (auth.uid() = id);

-- ============================================================
-- SESSIONS
-- One session = one idea refinement run
-- ============================================================

create table public.sessions (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references public.users(id) on delete cascade,
  idea_text     text not null,
  total_rounds  int not null default 0,
  status        text not null default 'in_progress'
                  check (status in ('in_progress', 'completed', 'cancelled')),
  is_public     boolean not null default false,
  share_slug    text unique,               -- /idea/[share_slug]
  total_cost_usd  numeric(10,6) default 0,
  created_at    timestamptz not null default now(),
  completed_at  timestamptz
);

-- Index for shareable URL lookups
create index sessions_share_slug_idx on public.sessions (share_slug) where share_slug is not null;
-- Index for user session history
create index sessions_user_id_idx on public.sessions (user_id, created_at desc);

-- RLS
alter table public.sessions enable row level security;
create policy "Users can read own sessions"   on public.sessions for select
  using (auth.uid() = user_id or is_public = true);
create policy "Users can insert own sessions" on public.sessions for insert
  with check (auth.uid() = user_id);
create policy "Users can update own sessions" on public.sessions for update
  using (auth.uid() = user_id);

-- ============================================================
-- ROUNDS
-- One round = one AI model's response within a session
-- ============================================================

create table public.rounds (
  id              uuid primary key default uuid_generate_v4(),
  session_id      uuid not null references public.sessions(id) on delete cascade,
  user_id         uuid not null references public.users(id) on delete cascade,
  round_number    int not null,            -- 1, 2, 3, 4
  role            text not null            -- critic | optimist | pragmatist | devil
                    check (role in ('critic', 'optimist', 'pragmatist', 'devil')),
  model           text not null,           -- e.g. claude-3-5-sonnet, gemini-flash
  input_text      text not null,           -- idea + previous round output
  output_text     text,                    -- null while streaming
  tokens_input    int,
  tokens_output   int,
  cost_usd        numeric(10,6),
  duration_ms     int,
  status          text not null default 'streaming'
                    check (status in ('streaming', 'completed', 'error')),
  error_code      text,
  created_at      timestamptz not null default now(),
  completed_at    timestamptz,

  unique (session_id, round_number)
);

-- Index for session round ordering
create index rounds_session_id_idx on public.rounds (session_id, round_number);

-- RLS
alter table public.rounds enable row level security;
create policy "Users can read own rounds" on public.rounds for select
  using (auth.uid() = user_id);
create policy "Service role inserts rounds" on public.rounds for insert
  with check (auth.uid() = user_id);

-- ============================================================
-- USER_QUOTAS
-- Per-user, per-day usage tracking for rate limiting
-- Edge Function checks this before every AI call
-- ============================================================

create table public.user_quotas (
  id              uuid primary key default uuid_generate_v4(),
  user_id         uuid not null references public.users(id) on delete cascade,
  date            date not null default current_date,
  rounds_used     int not null default 0,
  cost_usd        numeric(10,6) not null default 0,
  updated_at      timestamptz not null default now(),

  unique (user_id, date)
);

-- Index for fast quota lookups (hot path — called before every round)
create index user_quotas_user_date_idx on public.user_quotas (user_id, date);

-- RLS
alter table public.user_quotas enable row level security;
create policy "Users can read own quota"    on public.user_quotas for select using (auth.uid() = user_id);
create policy "Service role manages quotas" on public.user_quotas for all    using (auth.uid() = user_id);

-- ============================================================
-- TIER LIMITS VIEW
-- Used by Edge Function to check limits without hardcoding
-- ============================================================

create or replace view public.tier_limits as
select 'free'    as tier, 3   as daily_rounds_limit, 0.105 as daily_cost_ceiling_usd
union all
select 'pro',             50,                         1.75
union all
select 'creator',         200,                        7.00
union all
select 'team',            200,                        7.00;

-- ============================================================
-- HELPERS: updated_at trigger
-- ============================================================

create or replace function public.handle_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger users_updated_at        before update on public.users        for each row execute function public.handle_updated_at();
create trigger user_quotas_updated_at  before update on public.user_quotas  for each row execute function public.handle_updated_at();

-- ============================================================
-- NOTES
-- ============================================================
-- 1. Edge Function quota check flow:
--    SELECT rounds_used, cost_usd FROM user_quotas WHERE user_id=$1 AND date=CURRENT_DATE
--    JOIN tier_limits tl ON tl.tier = (SELECT tier FROM users WHERE id=$1)
--    IF rounds_used >= daily_rounds_limit OR cost_usd >= daily_cost_ceiling_usd → 429
--
-- 2. After round completes:
--    INSERT INTO user_quotas (user_id, date, rounds_used, cost_usd)
--    VALUES ($1, CURRENT_DATE, 1, $actual_cost)
--    ON CONFLICT (user_id, date) DO UPDATE
--    SET rounds_used = user_quotas.rounds_used + 1,
--        cost_usd    = user_quotas.cost_usd + EXCLUDED.cost_usd
--
-- 3. Shareable URL generation:
--    UPDATE sessions SET is_public=true, share_slug=nanoid(8) WHERE id=$1
--    URL: https://refinup.com/idea/[share_slug]
