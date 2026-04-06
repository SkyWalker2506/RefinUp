# RefinUp Brand Voice & Microcopy Guide

**Date:** 2026-04-06  
**Status:** Draft  
**Jira:** RFU-11

---

## Brand Voice Pillars

| # | Pillar | Means | Does NOT Mean |
|---|--------|-------|---------------|
| 1 | **Direct** | Say what you mean. No fluff. | Blunt or harsh |
| 2 | **Constructive** | Every critique comes with a direction forward | False positivity |
| 3 | **Honest** | We tell you what other AIs won't — including disagreement | Contrarian for its own sake |
| 4 | **Grounded** | Practical over theoretical. Real-world signal | Dry or corporate |
| 5 | **Respectful** | Treat the user's idea as worth taking seriously | Condescending |

---

## One-Line Positioning

> **"Tek model seni onaylar. RefinUp seni geliştirir."**  
> *(One model agrees with you. RefinUp improves you.)*

---

## AI Round Framing Language

Each AI round needs a header that tells the user what to expect. Keep it short and role-appropriate.

| Role | Turkish Header | English Header | Tone |
|------|---------------|----------------|------|
| Critic | "Eleştirmen bakışı" | "The Critic" | Sharp, honest |
| Optimist | "İyimser bakış" | "The Optimist" | Energizing, not naive |
| Pragmatist | "Pratik bakış" | "The Pragmatist" | Grounded, actionable |
| Devil's Advocate | "Şeytan avukatı" | "Devil's Advocate" | Challenging, provocative |

### Round intro phrases (use in UI above AI response):

```
Critic:    "Bu fikrin zayıf noktaları:"
Optimist:  "Bu fikrin güçlü potansiyeli:"
Pragmatist:"Hayata geçirmek için:"
Devil's:   "Kimse sormuyorsa, ben soruyorum:"
```

---

## Microcopy Patterns

### Input Field

```
Placeholder: "Bir fikrin mi var? Yaz, hep birlikte geliştirelim."
Label:       "Fikrin"
Max chars:   5000
Counter:     "2.340 / 5.000"
```

### CTA Buttons

| Context | Turkish | English |
|---------|---------|---------|
| Primary action | "Geliştir" | "Refine" |
| Start over | "Yeni Fikir" | "New Idea" |
| Share | "Paylaş" | "Share" |
| Upgrade | "Pro'ya Geç" | "Go Pro" |
| Free trial CTA | "Ücretsiz Dene" | "Try Free" |

### Loading / Streaming States

```
Before first round:  "Fikirini analiz ediyorum..."
During streaming:    "[Role adı] düşünüyor..."
Between rounds:      "Sıradaki bakış açısına geçiyor..."
All rounds done:     "Tüm bakış açıları hazır."
```

### Error Messages

| Error | Message | Action |
|-------|---------|--------|
| Network error | "Bağlantı kesildi. Kaldığın yerden devam edebilirsin." | "Tekrar Dene" |
| AI timeout | "Bu tur beklenenden uzun sürdü." | "Tekrar Dene" / "Atla" |
| Quota exceeded (free) | "Bugünkü 3 turun doldu. Yarın tekrar ya da Pro'ya geç." | "Pro'ya Geç" |
| Quota exceeded (pro) | "Bugünkü 50 turun doldu. Yarın sıfırlanır." | "Tamam" |
| Input too long | "En fazla 5.000 karakter girebilirsin." | — |

### Empty States

```
No sessions yet:  "Henüz bir fikir geliştirmedin. İlk adımı atmak için ne bekliyorsun?"
No shared ideas:  "Paylaşılmış fikir yok."
```

### Paywall / Upgrade

```
Trial end header:    "14 günlük denemin bitti."
Trial end body:      "Geliştirdiğin fikirlerin hepsine hâlâ sahipsin. Devam etmek için Pro seç."

Quota modal header:  "Bugünkü limitine ulaştın."
Quota modal body:    "Pro ile günde 50 tur — fikirlerini sınırsızca geliştirebilirsin."

Upgrade CTA:         "Pro'ya Geç — Aylık ₺X"
Secondary:           "Şimdilik kalsın"
```

### Onboarding Screens

```
Step 1:
  Title:    "Ne geliştirmek istiyorsun?"
  Subtitle: "Bir kategori seç — sana özel öneriler hazırlayalım."
  Options:  Girişim Fikri / Ürün Özelliği / İçerik / Araştırma / Diğer

Step 2:
  Title:    "İşte böyle çalışıyoruz"
  Subtitle: "Fikrin 3-4 farklı bakış açısından geçiyor. Her tur sana farklı bir perspektif sunuyor."

Step 3:
  Title:    "İlk fikrini yaz"
  Subtitle: "Kaba taslak da olsa sorun yok. RefinUp bunu geliştirecek."
  CTA:      "Geliştirmeye Başla"
```

---

## What NOT to Write

- ❌ "Mükemmel!", "Harika!", "Süper!" — boş onay, echo chamber'ı besler
- ❌ "Yapay zeka destekli..." — terim kullanma, aksiyonu öne çıkar
- ❌ Pasif cümle: "Fikriniz analiz edilmektedir" → "Fikirini analiz ediyorum"
- ❌ Aşırı teknik: "SSE stream başlatıldı" → "Yanıt geliyor..."
- ❌ Belirsiz: "Bir hata oluştu" → her zaman spesifik ol + aksiyon ver
