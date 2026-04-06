# RefinUp Monetization & Cost Analysis

**Date:** 2026-04-06  
**Status:** Draft — must be approved before freemium is launched  
**Jira:** RFU-12

---

## Pricing Tiers

| Tier | Price | Daily Rounds | Monthly Rounds | Target User |
|------|-------|-------------|----------------|-------------|
| **Free** | $0 | 3 rounds/day | ~90 | Casual exploration |
| **Pro** | $15/mo | 50 rounds/day | ~1,500 | Active solo creators |
| **Creator** | $29/mo | 200 rounds/day | ~6,000 | Power users, freelancers |
| **Team** | $49/user/mo | 200 rounds/day | ~6,000 | Small teams (2-10) |

Annual discount: 20% off (Pro: $12/mo, Creator: $23/mo)

---

## Cost Per Round

Based on OpenRouter pricing (April 2026 estimates):

### 2-Model Configuration (Minimum)

| Model | Input (per 1K tokens) | Output (per 1K tokens) | Avg tokens/round | Cost/round |
|-------|-----------------------|------------------------|------------------|------------|
| claude-3-5-haiku | $0.001 | $0.005 | 800 input / 400 output | $0.0028 |
| claude-3-5-sonnet | $0.003 | $0.015 | 800 input / 600 output | $0.0114 |
| **2-model total** | | | | **~$0.014/round** |

### 4-Model Configuration (Full Pipeline)

| Model | Cost/round |
|-------|-----------|
| claude-3-5-haiku (Critic) | $0.003 |
| claude-3-5-sonnet (Optimist) | $0.011 |
| claude-3-opus (Pragmatist) | $0.045 |
| gemini-flash (Devil's Advocate) | $0.002 |
| **4-model total** | **~$0.061/round** |

> **Default configuration: 3 models (~$0.035/round)**  
> User can configure; Pro/Creator tier gets 3-model default.

---

## Margin Analysis

### Pro Tier ($15/mo)

| Scenario | Rounds/mo | Cost @ $0.035/round | Revenue | **Margin** |
|----------|-----------|---------------------|---------|-----------|
| Light user (10% of limit) | 150 | $5.25 | $15 | **$9.75 (65%)** |
| Average user (30% of limit) | 450 | $15.75 | $15 | **-$0.75 (-5%)** |
| Heavy user (80% of limit) | 1,200 | $42.00 | $15 | **-$27 (-180%)** |

> **Risk:** Pro tier breaks even only if average utilization < 29% of limit.  
> **Mitigation:** Rate limit enforcement + monitor actual utilization before scaling marketing.

### Creator Tier ($29/mo)

| Scenario | Rounds/mo | Cost @ $0.035/round | Revenue | **Margin** |
|----------|-----------|---------------------|---------|-----------|
| Average (30%) | 1,800 | $63 | $29 | **-$34** |
| Light (10%) | 600 | $21 | $29 | **$8 (28%)** |

> **Creator tier is unprofitable at average utilization with 4-model config.**  
> **Mitigation:** Use 2-model config for Creator ($0.014/round), or price at $49/mo.

### Revised Safer Pricing

| Tier | Safe Price | Break-even utilization |
|------|-----------|----------------------|
| Pro | $19/mo | 45% utilization (3-model) |
| Creator | $39/mo | 37% utilization (3-model) |

---

## Free Tier Cost

| Metric | Value |
|--------|-------|
| Free rounds/day | 3 |
| Cost/day (3-model) | $0.105 |
| Cost/month (free user) | $3.15 |
| Acceptable CAC payback | 3 months |
| Max acceptable free users before paid | 100 (= $315/mo) |

> **Action:** Cap free tier at 3 rounds/day hard limit from day one.  
> No free trial with full access unless controlled (reverse trial cohort only).

---

## Reverse Trial Model

| Stage | Duration | Access |
|-------|---------|--------|
| Day 0-14 | 14 days | Full Pro access (50 rounds/day, 3 models) |
| Day 15+ | Ongoing | Drops to Free (3 rounds/day) unless paid |

**Expected conversion:** 8-12% (vs 2-5% without trial)  
**Cost of trial period:** 14 days × 50 rounds/day × $0.035 = **$24.50 max per trial user**  
**Break-even:** If >62% of trial users convert to Pro ($15/mo), trial cost is recovered in month 1.

---

## Monthly Cost Ceiling (Denial of Wallet Protection)

| Tier | Daily round limit | Max daily cost/user | Max monthly cost/user |
|------|-----------------|--------------------|-----------------------|
| Free | 3 | $0.105 | $3.15 |
| Pro | 50 | $1.75 | $52.50 |
| Creator | 200 | $7.00 | $210.00 |

> **Hard ceiling implementation:** Edge Function checks `cost_usd` in `user_quotas` table before each round. If `cost_usd >= daily_cost_ceiling`, reject with 429.

---

## Break-Even Analysis

At $0.035/round average:

| Monthly Paying Users | MRR (avg $17) | LLM Cost (200 rounds avg/user/mo) | **Profit** |
|---------------------|--------------|----------------------------------|-----------|
| 100 | $1,700 | $700 | $1,000 |
| 500 | $8,500 | $3,500 | $5,000 |
| 1,000 | $17,000 | $7,000 | $10,000 |
| 5,000 | $85,000 | $35,000 | $50,000 |

> LLM cost stabilizes at ~41% of revenue assuming typical utilization. This is sustainable.
