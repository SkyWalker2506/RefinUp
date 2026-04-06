# Analytics & Tracking Analiz Raporu
> Lead: A11 GrowthLead | Worker: M3 A/B Test Agent + M4 Analytics Agent | Model: Sonnet | Tarih: 2026-04-06

---

## Mevcut Durum

- Proje yeni/boş: hiç kod yok, tracking yok, event taxonomy yok
- Analytics platformu: seçilmemiş
- A/B test altyapısı: yok
- Privacy/KVKK uyumu: değerlendirilmemiş
- Puan: **1/10** (sadece başlangıç imkânı mevcut)

---

## Kritik Eksikler (hemen yapılmalı)

| # | Sorun | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Analytics platformu seçilmemiş | High | PostHog (open-source, KVKK dostu, A/B test built-in) veya Amplitude | S |
| 2 | Event taxonomy tanımlanmamış — sonradan eklemek veri tutarsızlığına yol açar | High | Koddan önce event taxonomy belgesi oluştur | S |
| 3 | "Aha moment" metriği tanımlanmamış | High | İlk başarılı refinement tamamlama = activation event | S |
| 4 | Funnel tanımlanmamış: kayıt → aktivasyon → retention → ödeme | High | AARRR veya HEART framework ile funnel map çiz | S |
| 5 | Privacy/GDPR-KVKK uyumu değerlendirilmemiş | High | Analytics verisi nerede saklandığına karar ver; EU data residency? | M |
| 6 | Error tracking yok | Med | Sentry entegrasyonu — kritik hataları gerçek zamanlı yakala | S |

---

## İyileştirme Önerileri (planlı)

| # | Öneri | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | **Core event taxonomy** — aşağıda detaylı | High | Uygulama başlamadan önce belge olarak kilitle | S |
| 2 | **Cohort analizi**: Kayıt haftasına göre D1/D7/D30 retention eğrileri | High | Amplitude veya PostHog cohort raporu | M |
| 3 | **A/B test altyapısı**: Freemium limit sayısı, onboarding akışı, paywall mesajı | High | PostHog feature flags veya GrowthBook (open-source) | M |
| 4 | **Funnel drop-off analizi**: Hangi adımda kullanıcı kaybediliyor? | High | Step-by-step funnel event'leri + heatmap | M |
| 5 | **Revenue analytics**: MRR, churn, LTV, CAC takibi | High | Stripe + analytics entegrasyonu | M |
| 6 | **Model performans metrikleri**: Hangi AI modeli kullanıcı memnuniyeti aldı? Refinement'ta geçirilen süre? | Med | Custom event: `refinement_completed` → `model`, `duration`, `rating` property'leri | S |
| 7 | **Share event tracking**: Paylaşılan output'ların viral katsayısını ölç (K-factor) | High | `output_shared` event → referrer tracking → `signup_via_share` attribution | M |
| 8 | **Session recording**: Kullanıcı nerede takılıyor? | Med | PostHog session replay veya Hotjar | S |
| 9 | **NPS / CSAT**: Refinement sonrası tek soruluk memnuniyet | Med | In-app survey, haftalık cohort bazlı | S |
| 10 | **Gelir attribution**: Hangi kanal, hangi içerik, hangi referrer ödemeye dönüştü? | High | UTM parametreleri + Stripe metadata | M |

---

## Önerilen Event Taxonomy (AI Fikir Geliştirme Platformu)

### Kimlik / Auth
```
user_signed_up         { method: "google"|"email", source: utm_source }
user_logged_in         { method }
user_logged_out
```

### Onboarding
```
onboarding_started
onboarding_step_completed  { step: 1|2|3, step_name }
onboarding_completed
onboarding_skipped         { at_step }
```

### Core Feature — Refinement
```
idea_submitted         { char_count, category?, is_first }
refinement_started     { model_count, models: [] }
model_response_received { model_name, duration_ms, token_count }
refinement_completed   { total_duration_ms, models: [], idea_id }
refinement_failed      { error_type, model_name }
refinement_rating      { idea_id, rating: 1-5, model_ratings: {} }
```

### Output / Paylaşım (Viral Loop)
```
output_viewed          { idea_id, is_owner }
output_shared          { idea_id, channel: "twitter"|"linkedin"|"copy_link" }
output_shared_via_link { idea_id, referrer_user_id }  ← viral attribution
output_saved           { idea_id }
output_deleted         { idea_id }
```

### Ödeme / Abonelik
```
paywall_hit            { trigger: "limit"|"feature", plan_shown }
upgrade_clicked        { from_plan, to_plan, trigger }
subscription_started   { plan, billing_cycle, revenue }
subscription_cancelled { plan, reason?, churn_day }
subscription_renewed   { plan }
```

### Engagement
```
session_started        { device, platform }
feature_discovered     { feature_name }
limit_reached          { limit_type: "monthly_refinements"|"models" }
notification_received  { type }
notification_clicked   { type }
```

---

## Kesin Olmalı (industry standard)

- **Event taxonomy belgesi** koddan önce yazılmalı — Amplitude/Mixpanel implemente ederken haftalar gecikmemek için
- **UTM parametresi takibi**: Her dış bağlantıda `utm_source`, `utm_medium`, `utm_campaign`
- **User ID anonim → authenticated merge**: Kayıt öncesi davranışı kayıt sonrasına bağla
- **Server-side events**: Kritik ödeme eventleri client-side değil server-side gönderilmeli
- **Data retention politikası**: KVKK/GDPR için kullanıcı verisi saklama süresi belirlenmeli
- **Dashboard**: Haftalık KPI dashboard — DAU/WAU/MAU, activation rate, D7 retention, MRR

---

## Kesin Değişmeli (mevcut sorunlar)

- Taxonomy sonradan tasarlanırsa veri tutarsızlığı kaçınılmaz — Heap otomatik yakalıyor ama Amplitude/PostHog için planlama zorunlu.
- "Aha moment" tanımlanmadan A/B test anlamsız — önce neyi optimize ettiğini bil.
- AI platformlarında Day 7 retention kritik tahmin metriği: eğer kullanıcı 7. günde geri gelmiyorsa ödemeye de geçmeyecek. Bu metrik ilk sprint'ten itibaren izlenmeli.

---

## Nice-to-Have (diferansiasyon)

- **AI model leaderboard**: Kullanıcı rating'lerine göre hangi model hangi fikir kategorisinde daha iyi? — ürün içi ve public istatistik
- **Predictive churn**: ML tabanlı churn tahmini (Amplitude AI bu özelliği 2025'te çıkardı)
- **Cohort'a göre A/B test**: Farklı kullanıcı segmentlerine farklı özellikler — early adopter vs casual user
- **Revenue forecasting**: MRR büyüme tahmini — Stripe + cohort verisi kombinasyonu
- **Viral coefficient (K-factor) dashboard**: `K = paylaşım başına yeni kayıt / paylaşım sayısı` — K > 1 hedefi

---

## Referanslar

- [Amplitude vs Mixpanel vs PostHog — Startupik](https://startupik.com/best-product-analytics-tools-compared-amplitude-vs-mixpanel-vs-posthog/)
- [Activation metrics that actually predict retention — RevenueCat](https://www.revenuecat.com/blog/growth/activation-metrics/)
- [Top 10 Metrics to Measure Freemium and Free Trial Performance — Amplitude](https://amplitude.com/blog/freemium-free-trial-metrics)
- [The SaaS Retention Report: The AI churn wave — ChartMogul](https://chartmogul.com/reports/saas-retention-the-ai-churn-wave/)
- [User Activation Rate Benchmarks 2025 — Agile Growth Labs](https://www.agilegrowthlabs.com/blog/user-activation-rate-benchmarks-2025/)
