# #5 Monetization & Business Model — Analiz Raporu

> Lead: A12 BizLead | Worker: H3 Revenue Analyst + H4 Pricing Strategist | Model: Sonnet | Tarih: 2026-04-06

---

## Mevcut Durum

- Proje yeni/boş: kod yok, fiyatlandırma kararı verilmemiş
- README'de "Freemium" ifadesi var — detay yok
- Puan: **2/10** (fikir var, strateji yok)

---

## Kritik Eksikler (hemen yapılmalı)

| # | Sorun | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Freemium limitleri tanımsız (kaç tur? kaç model?) | High | Free tier sınırlarını netleştir (öneri: 3 tur/gün, 2 model) | S |
| 2 | Ücretli tier fiyatı ve içeriği belirsiz | High | En az 2 ücretli tier tasarla (Pro + Team) | M |
| 3 | Maliyet yapısı hesaplanmamış (API maliyeti / kullanıcı / tur) | High | LLM API maliyetlerini tur başına hesapla, margin belirle | M |
| 4 | Ödeme altyapısı seçilmemiş | High | Stripe veya RevenueCat belirle | S |

---

## İyileştirme Önerileri (planlı)

| # | Öneri | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Usage-based credit sistemi ekle | High | Tur = 1 kredi; kredi paketi sat ($5/50 kredi) | M |
| 2 | Reverse trial dene (14 gün tam erişim → kısıtlı) | High | Freemium yerine reverse trial; konversiyon %2-5 → %8-12'ye çıkabilir | M |
| 3 | Team/Enterprise tier için çoklu kullanıcı faturalama | Med | Seat-based pricing ($X/kullanıcı/ay) + kurumsal SSO | L |
| 4 | Yıllık ödeme indirimi (%20) | Med | Yıllık taahhüt → churn düşürür, LTV artırır | S |
| 5 | Model seçim paketleri (GPT-only vs. All Models) | Med | Premium tiers'da daha pahalı model erişimi | M |

---

## Önerilen Fiyatlandırma Yapısı

### Free Tier (Ücretsiz)
- 3 tur/gün
- 2 AI modeli (GPT-4o + Claude Sonnet)
- Tur başına 1 bakış açısı
- Kayıt gerektirir

### Pro — $15/ay ($12/ay yıllık)
- 50 tur/ay
- 5 AI modeli (GPT, Claude, Gemini, Grok, Mistral)
- Tur başına 3 bakış açısı
- Geçmiş kayıt + export

### Creator — $29/ay ($24/ay yıllık)
- 200 tur/ay
- Tüm modeller
- Özelleştirilebilir rol tanımları
- API erişimi (beta)

### Team — $49/kullanıcı/ay (min. 3 kullanıcı)
- Unlimited tur
- Ortak çalışma alanı
- Admin dashboard
- Öncelikli destek

---

## Benchmark Karşılaştırması

| Platform | Free Limit | Pro Fiyat | Model |
|----------|-----------|-----------|-------|
| Poe | 100 msg/gün | $5-$20/ay | Point-based |
| Perplexity | 5 Pro arama/gün | $20/ay | Subscription |
| Notion AI | ~20 yanıt (trial) | $20/kullanıcı/ay | Seat-based |
| ChatGPT | GPT-3.5 sınırsız | $20/ay (Plus) | Subscription |
| **RefinUp (öneri)** | **3 tur/gün** | **$15/ay** | **Hybrid (sub + credit)** |

---

## Kesin Olmalı (industry standard)

- Kredi/tur bazlı kullanım takibi — kullanıcı ne kadar harcadığını görmeli
- Freemium → ücretli yönlendirme (kullanım limitine yaklaştığında prompt)
- Yıllık / aylık fatura seçeneği
- Stripe ile güvenli ödeme
- Açık iptal politikası (self-serve cancel)
- Free tier'da kredi kartı isteme — sürtüşme yaratır

---

## Kesin Değişmeli (gelecekte sorun olacak)

- Sınırsız tur vaat etme (LLM maliyeti kontrol dışına çıkar)
- Tek tier strateji (free vs. paid ikili) — gelir tavanı düşürür
- Model bazlı fiyatlandırmayı gizleme — şeffaflık güven yaratır

---

## Nice-to-Have (diferansiasyon)

- Outcome-based pricing dene: "fikir raporu başına $X" (enterprise için)
- Affiliate/referral programı: "3 arkadaşını davet et, 1 ay Pro kazan"
- API erişimi — geliştiricilere B2B kanal (Cursor modeli)
- Non-profit / öğrenci planı: %50 indirim, güven inşa eder

---

## Maliyet Analizi (tahmin)

| Senaryo | Maliyet/Tur | Marj (Pro $15/ay) |
|---------|------------|-------------------|
| GPT-4o + Claude Sonnet, 3 tur | ~$0.08 | 50 tur × $0.08 = $4 maliyet → %73 marj |
| Tüm modeller, 4 tur | ~$0.20 | 50 tur × $0.20 = $10 maliyet → %33 marj |

> Not: Creator/Team tier'da model maliyeti artar — fiyat buna göre kalibre edilmeli.

---

## Referanslar

- [SaaS Freemium Conversion Rates 2026 — First Page Sage](https://firstpagesage.com/seo-blog/saas-freemium-conversion-rates/)
- [Freemium to Paid Benchmarks — Guru Startups](https://www.gurustartups.com/reports/freemium-to-paid-conversion-rate-benchmarks)
- [AI Pricing Models Explained — Data-Mania](https://www.data-mania.com/blog/ai-pricing-models-explained-usage-seats-credits-outcome-based-options/)
- [How to Price AI Products (2026) — Aakash Gupta](https://www.news.aakashg.com/p/how-to-price-ai-products)
- [AI Credits & Billing — Metronome](https://metronome.com/blog/the-rise-of-ai-credits-why-cost-plus-credit-models-work-until-they-dont)
- [Sustainable AI Subscription Pricing — RevenueCat](https://www.revenuecat.com/blog/growth/ai-subscription-app-pricing/)
- [Poe AI Pricing 2025 — TechCrunch](https://techcrunch.com/2025/03/25/quoras-poe-now-offers-an-affordable-subscription-plan-for-5-month/)
- [Perplexity Pricing — Juma AI](https://juma.ai/blog/perplexity-pricing)
