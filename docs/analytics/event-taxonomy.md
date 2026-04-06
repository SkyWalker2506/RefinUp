# RefinUp Event Taxonomy

**Date:** 2026-04-06  
**Status:** Draft — must be finalized before any tracking code is written  
**Tool:** PostHog  
**Jira:** RFU-9

---

## Naming Convention

```
<noun>_<verb>         # object + action
idea_submitted        # good
clicked_button        # bad (too generic)

Properties: snake_case
Event names: snake_case
```

---

## Core Funnel Events

### Authentication

| Event | Trigger | Properties |
|-------|---------|------------|
| `user_signed_up` | Successful registration | `method` (google/email), `source` (landing/direct) |
| `user_logged_in` | Successful login | `method` (google/email) |
| `user_logged_out` | Logout action | — |

### Onboarding

| Event | Trigger | Properties |
|-------|---------|------------|
| `onboarding_started` | First login, onboarding shown | — |
| `onboarding_step_completed` | Each step completed | `step` (1/2/3), `use_case` (founder/pm/writer/researcher) |
| `onboarding_completed` | All 3 steps done | `time_to_complete_seconds` |
| `onboarding_skipped` | Skip button tapped | `step_skipped_at` (1/2/3) |

### Idea Submission (Aha Moment Funnel)

| Event | Trigger | Properties |
|-------|---------|------------|
| `idea_draft_started` | User starts typing in input | — |
| `idea_submitted` | User submits idea for refinement | `idea_length` (chars), `session_id` |
| `idea_cancelled` | User cancels before submitting | `idea_length` |

### AI Refinement (Core Loop)

| Event | Trigger | Properties |
|-------|---------|------------|
| `round_started` | AI round begins | `session_id`, `round_number` (1-4), `role` (critic/optimist/pragmatist/devil), `model` |
| `round_streaming` | First chunk received | `session_id`, `round_number`, `time_to_first_token_ms` |
| `round_completed` | AI round finishes | `session_id`, `round_number`, `role`, `model`, `tokens_used`, `cost_usd`, `duration_ms` |
| `round_error` | AI round fails | `session_id`, `round_number`, `error_code`, `retried` (bool) |
| `round_retried` | User retries failed round | `session_id`, `round_number`, `retry_count` |

### **⭐ Aha Moment**

| Event | Trigger | Properties |
|-------|---------|------------|
| `refinement_completed` | All rounds in session finish | `session_id`, `total_rounds`, `total_duration_ms`, `total_cost_usd`, `from_onboarding` (bool) |

> **This is the single most important event.** It marks the "aha moment". Day 7 retention target: 40%+ of users who fired this event.

### Sharing (Viral Loop)

| Event | Trigger | Properties |
|-------|---------|------------|
| `share_url_created` | User creates shareable link | `session_id`, `visibility` (public/private) |
| `share_url_copied` | Copy button tapped | `session_id` |
| `shared_idea_viewed` | Visitor views a shared /idea/[id] page | `session_id`, `referrer_source` |
| `shared_idea_signup_cta_clicked` | CTA on shared page clicked | `session_id` |

### Quota & Paywall

| Event | Trigger | Properties |
|-------|---------|------------|
| `quota_warning_shown` | User reaches 80% of daily limit | `tier`, `rounds_used`, `rounds_limit` |
| `quota_exceeded` | User hits daily limit | `tier` |
| `paywall_shown` | Upgrade modal appears | `trigger` (quota/trial_end/feature) |
| `paywall_dismissed` | User closes paywall | `trigger` |
| `upgrade_clicked` | User clicks upgrade CTA | `trigger`, `target_tier` (pro/creator/team) |

### Billing

| Event | Trigger | Properties |
|-------|---------|------------|
| `checkout_started` | Stripe checkout initiated | `tier`, `billing_period` (monthly/annual) |
| `subscription_created` | Successful payment | `tier`, `billing_period`, `mrr_usd` |
| `subscription_cancelled` | Cancellation | `tier`, `reason` (survey), `months_active` |
| `trial_started` | Reverse trial begins | `tier` (pro) |
| `trial_day_12_warning` | D12 notification sent | — |
| `trial_ended` | Trial expires | `converted` (bool) |

### SEO / Landing Page

| Event | Trigger | Properties |
|-------|---------|------------|
| `landing_page_viewed` | Landing page load | `source` (organic/paid/referral/llm), `utm_*` |
| `landing_cta_clicked` | "Ücretsiz Dene" click | `cta_location` (hero/pricing/footer) |
| `pricing_viewed` | Pricing section visible | — |

---

## PostHog Configuration

```dart
// lib/core/analytics/analytics_service.dart
class AnalyticsService {
  static const _aha_moment = 'refinement_completed';
  
  Future<void> track(String event, [Map<String, dynamic>? props]) async {
    await PostHog().capture(
      eventName: event,
      properties: props,
    );
  }
  
  // Convenience methods for critical events
  Future<void> trackAhaMoment(String sessionId, int totalRounds, int durationMs) async {
    await track(_aha_moment, {
      'session_id': sessionId,
      'total_rounds': totalRounds,
      'total_duration_ms': durationMs,
    });
  }
}
```

---

## Key Metrics to Build Dashboards From

| Metric | Formula | Target |
|--------|---------|--------|
| Activation Rate | `refinement_completed` / `user_signed_up` | > 60% |
| Day 7 Retention | Users who did `refinement_completed` on D7 / D0 | > 40% |
| Viral Coefficient | `shared_idea_signup_cta_clicked` / `share_url_created` | > 0.3 |
| Paywall Conversion | `upgrade_clicked` / `paywall_shown` | > 15% |
| Trial Conversion | `subscription_created` where `trial_started` | > 8% |
