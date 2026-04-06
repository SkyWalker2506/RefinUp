# ADR-002: Backend-for-Frontend (BFF) Architecture

**Date:** 2026-04-06  
**Status:** Accepted  
**Jira:** RFU-6

---

## Context

RefinUp makes multi-model AI calls via OpenRouter. The API key must never reach the client. We also need SSE streaming, per-user rate limiting, and cost tracking — all of which require a server-side layer.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENT (Flutter)                      │
│                                                              │
│  User Input ──► RefinementScreen                            │
│                      │                                       │
│                 StreamBuilder                                 │
│                      │ SSE chunks                            │
└──────────────────────┼──────────────────────────────────────┘
                        │ HTTPS + SSE
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              SUPABASE EDGE FUNCTION (BFF)                    │
│                                                              │
│  1. Authenticate JWT (Supabase Auth)                        │
│  2. Check user quota (user_quotas table via RLS)            │
│  3. Sanitize input (strip HTML, max 5000 chars)             │
│  4. Call OpenRouter API (API key server-side only)          │
│  5. Stream response back via SSE                            │
│  6. Log round (rounds table: model, tokens, cost)           │
│  7. Increment user_quotas.rounds_used                       │
└──────────────────────┬──────────────────────────────────────┘
                        │
           ┌────────────┴────────────┐
           ▼                         ▼
┌──────────────────┐      ┌──────────────────────┐
│   OpenRouter API  │      │   Supabase Database   │
│                  │      │                        │
│  - Model routing │      │  - users               │
│  - SSE streaming │      │  - sessions            │
│  - Fallback      │      │  - rounds              │
└──────────────────┘      │  - user_quotas         │
                          └──────────────────────┘
```

## Decision

All AI API calls go through a Supabase Edge Function. The OpenRouter API key is stored as an Edge Function secret, never in client code or environment variables accessible to the frontend.

## SSE Streaming Protocol

```
Client → POST /functions/v1/refine
  Body: { session_id, idea_text, round_number, role }
  
Server → SSE stream:
  event: round_start
  data: { round: 1, role: "critic", model: "claude-3-5-sonnet" }

  event: chunk
  data: { text: "Your idea..." }
  
  event: chunk  
  data: { text: " has potential but..." }
  
  event: round_complete
  data: { round: 1, tokens_used: 450, cost_usd: 0.004 }

  event: error
  data: { code: "QUOTA_EXCEEDED", message: "..." }
```

## Rate Limiting

```
1. Before calling OpenRouter:
   SELECT rounds_used, cost_usd FROM user_quotas 
   WHERE user_id = $1 AND date = CURRENT_DATE
   
2. If rounds_used >= tier_limit → return 429
3. If cost_usd >= daily_cost_ceiling → return 429

4. After round completes:
   INSERT INTO user_quotas ... ON CONFLICT DO UPDATE
   SET rounds_used = rounds_used + 1, cost_usd = cost_usd + $actual_cost
```

## Error Handling

| Error | Client Behavior |
|-------|----------------|
| 401 Unauthorized | Redirect to login |
| 429 Quota Exceeded | Show upgrade modal |
| 503 AI Unavailable | Show retry option (3x backoff) |
| 408 Timeout | Show "AI is taking long" + cancel option |

## Security Properties

- API key: Edge Function secret only, never in client bundle
- JWT required: every request authenticated
- Input sanitized: before reaching OpenRouter
- Context cleared: between rounds (no cross-session injection surface)

## Consequences

- **Positive:** API key never exposed; rate limiting enforced server-side
- **Positive:** Cost tracking automatic per round
- **Negative:** Edge Function cold start adds ~200ms to first request per session
- **Mitigation:** Keep-warm strategy for Edge Functions in production
