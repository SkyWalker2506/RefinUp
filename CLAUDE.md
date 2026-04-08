# RefinUp — Claude Kural Dosyası

> Genel kurallar `~/Projects/claude-config/CLAUDE.md` dosyasındadır ve burada da geçerlidir.

## Proje Özeti

**RefinUp** — Multi-AI fikir geliştirme platformu. Kullanıcı bir fikir girer; sistem bunu birden fazla AI modeline sırayla sorar, her model bir öncekinin çıktısını geliştirir.

- **Stack:** Flutter (web + iOS + Android) + Supabase (PostgreSQL + Edge Functions)
- **AI Gateway:** OpenRouter via Supabase Edge Functions (BFF — API key asla client'a çıkmaz)
- **State:** Riverpod
- **Analytics:** PostHog
- **Hata Takibi:** Sentry

## Kritik Güvenlik Kuralları

1. **OpenRouter API key asla Flutter koduna girmez** — yalnızca Supabase Edge Function secret
2. **Firebase `allow read, write: if true` ile deploy edilmez** — RLS zorunlu
3. **Her Edge Function çağrısında:** JWT doğrula → quota kontrol et → input sanitize et → OpenRouter çağır
4. **Input limiti:** 5000 karakter, HTML strip, prompt injection önlemi

## Mimari Kararlar (ADR)

| ADR | Karar | Durum |
|-----|-------|-------|
| ADR-001 | Flutter + Supabase stack | Accepted |
| ADR-002 | BFF (Backend-for-Frontend) mimarisi | Accepted |

Yeni mimari karar için `docs/adr/` altına `003-*.md` oluştur.

## Sprint Durumu

| Sprint | Kapsam | Tarih | Durum |
|--------|--------|-------|-------|
| Sprint 0 | Temel kararlar ve belgeler | 7–13 Apr 2026 | Tamamlandı |
| Sprint 1 | Flutter iskeleti + güvenlik temeli | 14–27 Apr 2026 | Planlandı |
| Sprint 2 | Core feature + growth temeli | 28 Apr – 11 May 2026 | Planlandı |

## Belge Rehberi

| Belge | Konum | Amaç |
|-------|-------|------|
| Master Analysis | `analysis/MASTER_ANALYSIS.md` | 11 kategoride tam analiz, Top 20 aksiyon |
| Design Tokens | `docs/design-system/tokens.md` | Renk, tipografi, spacing, animasyon |
| Event Taxonomy | `docs/analytics/event-taxonomy.md` | PostHog olayları — koddan önce okunmalı |
| Brand Voice | `docs/content/brand-voice.md` | Microcopy, hata mesajları, CTA metinleri |
| Monetization | `docs/business/monetization-cost-table.md` | Tier fiyatları, maliyet analizi |
| WCAG Rules | `docs/accessibility/wcag-rules.md` | Flutter Semantics API zorunlu kuralları |
| DB Schema | `docs/database/schema.sql` | Supabase tablo tanımları |
| ADR-001 | `docs/adr/001-stack-decision.md` | Flutter + Supabase kararı |
| ADR-002 | `docs/adr/002-bff-architecture.md` | BFF + SSE streaming mimarisi |

## Klasör Yapısı (Dart)

```
lib/
  features/
    auth/           # Google + email login
    refinement/     # Ana AI zincir akışı
    billing/        # Stripe / freemium
    onboarding/     # 3 adımlı onboarding
  core/
    network/        # Supabase client, SSE
    storage/        # Local cache
    theme/          # AppColors, AppTextStyles, AppSpacing
    utils/          # Input sanitizer, validators
  shared/
    widgets/        # RoundBadge, StreamingText, StepIndicator
    models/         # Session, Round, UserQuota
```

## Geliştirme Kuralları

1. **Önce belge, sonra kod** — event taxonomy ve microcopy okunmadan UI yazılmaz
2. **Her custom widget'ta Semantics** — WCAG 2.1 AA zorunlu
3. **Streaming state her zaman gösterilir** — kullanıcı "AI düşünüyor" durumunu görmeli
4. **PR review'da:** güvenlik (API key ifşası?), WCAG kontrolü, event tracking eklendi mi?
5. **Maliyet tavanı:** Edge Function'da `cost_usd >= daily_cost_ceiling` kontrolü zorunlu

## Jira

- Jira projesi: Oluşturulacak (şu an yok)
- GitHub: [SkyWalker2506/RefinUp](https://github.com/SkyWalker2506/RefinUp)

## First-Mover Penceresi

**3–6 ay** — Poe/Perplexity benzer özellik ekleyebilir. Sprint 1 gecikmesi doğrudan pazar kaybıdır.
