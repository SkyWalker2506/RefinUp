# ADR-001: Flutter + Supabase Stack Decision

**Date:** 2026-04-06  
**Status:** Accepted  
**Jira:** RFU-13

---

## Context

RefinUp is an AI-powered idea refinement platform. We need to choose a primary tech stack before any development begins. The platform must support web and mobile from a single codebase, handle real-time AI streaming, manage per-user quotas, and scale from 0 to tens of thousands of users.

## Decision

**Frontend:** Flutter (web + iOS + Android — single codebase)  
**Backend/DB:** Supabase (PostgreSQL + Row Level Security + Edge Functions + Realtime)  
**AI Gateway:** OpenRouter via Supabase Edge Functions (server-side proxy, never client-side)  
**State Management:** Riverpod  
**Error Tracking:** Sentry  
**Analytics:** PostHog  

## Folder Structure

```
lib/
  features/
    auth/
    refinement/
    billing/
    onboarding/
  core/
    network/
    storage/
    theme/
    utils/
  shared/
    widgets/
    models/
```

## Rationale

| Criterion | Flutter | React Native | Native |
|-----------|---------|--------------|--------|
| Single codebase (web + mobile) | ✅ | ✅ | ❌ |
| Web WASM renderer (LCP < 2.5s) | ✅ | ❌ | N/A |
| Strong typing | ✅ | Partial | ✅ |
| Team familiarity | ✅ | ❌ | ❌ |

| Criterion | Supabase | Firebase | Custom |
|-----------|----------|----------|--------|
| PostgreSQL (relational quotas) | ✅ | ❌ | ✅ |
| Row Level Security | ✅ | Partial | Manual |
| Edge Functions (BFF) | ✅ | ✅ | ✅ |
| Open source / no vendor lock | ✅ | ❌ | ✅ |
| Self-hostable | ✅ | ❌ | ✅ |

## Consequences

- **Positive:** Single codebase reduces maintenance; RLS simplifies quota enforcement; Edge Functions eliminate need for separate backend server
- **Positive:** Flutter WASM enables near-native web performance
- **Negative:** Flutter web ecosystem less mature than React for SEO (mitigated by SSR landing page)
- **Risk:** Supabase Edge Function cold start (~200ms) — acceptable for AI-gated flows

## Dependencies on This Decision

All other architectural decisions depend on this being confirmed first. No code should be written until this ADR is accepted.
