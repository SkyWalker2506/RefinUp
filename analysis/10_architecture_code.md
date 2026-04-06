# #10 Architecture & Code Quality Analiz Raporu

> Lead: A10 CodeLead | Worker: B1 Backend Architect + B8 Refactor Agent | Model: Opus | Tarih: 2026-04-06

---

## Mevcut Durum

- Proje yeni/boş: kod yok, mimari kararlar alınmamış
- Bu rapor; platform, backend, AI entegrasyon ve kod organizasyon kararlarını kapsar
- **Puan: N/A** (kod yok; mimari seçimlere göre 3-9/10 arasında değişir)

---

## Kritik Mimari Kararlar

### 1. Platform Seçimi: Flutter vs React Native vs Web-Only

| Kriter | Flutter | React Native | Web-Only (Next.js) |
|--------|---------|--------------|-------------------|
| Kod paylaşımı (web+mobil+desktop) | %95+ | %60-70 (web paylaşımı zor) | Web only |
| Web performansı | WASM ile iyi, başlangıçta yavaş | Zayıf | Native, mükemmel |
| Mobil performans | Mükemmel | İyi (yeni mimari) | PWA olarak kabul edilebilir |
| Desktop desteği | Native (Win/Mac/Linux) | Yok | Electron gerekir |
| Dart öğrenme eğrisi | Orta | Düşük (JS) | Düşük |
| Talent pool | Dar | Geniş | Çok geniş |
| Flutter SEO | Zayıf (web için) | Zayıf | Mükemmel |

**Öneri:** RefinUp için **Flutter** tercih edilebilir — cross-platform gerekliliği var (Web+iOS+Android+Desktop), UI yoğun uygulama, WASM desteği ile web performansı kabul edilebilir seviyeye geldi. **Ancak** SEO önemliyse (arama motoru trafiği) landing page + auth için Next.js, uygulama için Flutter hibrit yaklaşım düşünülmeli.

---

### 2. Backend Seçimi: Firebase vs Supabase vs Custom

| Kriter | Firebase | Supabase | Custom (FastAPI/Node) |
|--------|----------|----------|----------------------|
| Başlangıç hızı | Çok hızlı | Hızlı | Yavaş |
| Freemium yönetimi | Karmaşık (Firestore rules) | RLS ile güçlü | Tam kontrol |
| Realtime | Mükemmel | İyi | SSE/WS ile yapılır |
| AI tur verisi ilişkilendirme | NoSQL = zor join | PostgreSQL = kolay | Esnek |
| Vendor lock-in | Yüksek (Google Cloud) | Düşük (self-hostable) | Yok |
| Maliyet öngörüsü | Okuma/yazma bazlı, sürpriz | Kaynak bazlı, öngörülü | Değişken |
| Auth (Google/email) | Yerleşik, mükemmel | Yerleşik | Ekstra iş |

**Öneri:** **Supabase** — RefinUp için yapısal veri şeması önemli (kullanıcı → oturum → tur → AI yanıt ilişkisi). PostgreSQL bu ilişkileri doğal kurar. Row-Level Security ile freemium kota yönetimi kolaydır. Firebase'in NoSQL yapısı "tur → önceki çıktı → sonraki çıktı" zincirini modellemekte zorlar.

---

### 3. OpenRouter Entegrasyon Mimarisi

**Kesinlikle yapılmaması gereken:** Frontend'den doğrudan OpenRouter API çağrısı.
- API key'i expose eder
- Rate limiting kontrol edilemez
- Kullanıcı başına maliyet takibi imkânsız

**Doğru mimari:**

```
Kullanıcı
  ↓
Flutter App
  ↓ (kendi backend)
Backend API (Supabase Edge Function / FastAPI)
  ├── Kullanıcı kimlik doğrulama
  ├── Kota kontrolü (freemium limit)
  ├── Rate limiting (per-user)
  └── OpenRouter API çağrısı (server-side key)
        ↓
      AI Model (GPT/Gemini/Claude vb.)
        ↓ (SSE stream)
      Backend → Client (SSE forward)
```

**Kritik:** Backend, OpenRouter yanıtını doğrudan client'a SSE olarak proxy etmeli. Tüm yanıtı bekleyip sonra göndermek UX'i mahveder.

---

### 4. Kullanıcı Başına AI Tur Yönetimi

**Veri modeli (Supabase/PostgreSQL):**

```
users
  └── sessions (bir fikir geliştirme oturumu)
        └── rounds (her AI turu)
              ├── model_id (hangi AI)
              ├── role (eleştirmen/iyimser/pragmatist)
              ├── input_text (önceki turun çıktısı)
              ├── output_text (bu turun çıktısı)
              ├── tokens_used
              └── cost_usd

user_quotas
  ├── monthly_rounds_used
  ├── monthly_rounds_limit (freemium=10, premium=unlimited)
  └── reset_date
```

**Kota enforcement:** Supabase RLS + Edge Function middleware — her tur başlamadan önce kota kontrolü.

---

## Kritik Eksikler (hemen yapılmalı)

| # | Sorun | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Platform/backend kararı verilmemiş — her şey bu karara bağlı | High | Flutter + Supabase stack kararını confirm et ve proje iskeletini kur | S |
| 2 | OpenRouter API key management stratejisi yok — frontend'e sızdırılırsa felaket | High | Server-side proxy mimarisi tasarla; API key sadece backend'de | S |
| 3 | Freemium kota sistemi için veri modeli tanımlanmamış | High | Supabase schema: users, sessions, rounds, user_quotas tabloları | M |
| 4 | Sequential AI pipeline'da hata yönetimi yok — bir model başarısız olursa ne olur? | High | Her tur için retry (3x), fallback model, kullanıcıya devam/iptal seçeneği | M |
| 5 | Kod organizasyonu için mimari pattern seçilmemiş (Clean Architecture vs layered) | Med | Feature-first klasör yapısı + repository pattern; Flutter'da Riverpod | M |

---

## İyileştirme Önerileri (planlı)

| # | Öneri | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | AI model seçimi için strateji pattern — her model için standart interface | High | `AIModel` abstract class; her model (GPT, Gemini, Claude) implementasyonu | M |
| 2 | Oturum paylaşımı — kullanıcı sonucu başkasıyla paylaşabilsin | Med | Read-only session URL; public/private toggle; Supabase RLS | M |
| 3 | Webhook/event sistemi — tur tamamlandığında bildirim (push notification) | Med | Firebase Messaging veya Supabase Realtime subscription | M |
| 4 | Admin panel — maliyet takibi, kullanıcı kota yönetimi | Med | Supabase Studio yeterli başlangıç için; ileride custom dashboard | L |
| 5 | Multi-tenant API key — premium kullanıcılar kendi OpenRouter key'ini girebilsin | Low | Encrypted key storage; kullanıcı kendi maliyetini öder | M |

---

## Kesin Olmalı (industry standard)

- **Server-side API proxy** — hiçbir AI API key'i frontend'e ulaşmamalı
- **Environment-based config** — dev/staging/prod ortamları ayrı; `.env` şablonu proje başında
- **Auth middleware** — her API endpoint'i kimlik doğrulama gerektirmeli (Supabase JWT)
- **Input validation** — kullanıcı fikirlerini sanitize et; prompt injection saldırılarına karşı
- **Database migrations** — Supabase migration dosyaları version control'de; `db/migrations/`
- **Error logging** — Sentry veya benzeri; frontend + backend hatalar merkezi toplanmalı
- **Feature-first klasör yapısı:**
  ```
  lib/
    features/
      idea_session/   (oturum oluşturma + görüntüleme)
      ai_rounds/      (tur yönetimi + streaming)
      auth/           (login, register)
      subscription/   (freemium, ödeme)
    core/
      api/
      models/
      utils/
  ```

---

## Kesin Değişmeli (mevcut sorunlar)

Proje henüz kod yok. Ancak şu mimari hataların baştan engellenmesi gerekir:

- **God class / God service** — tek bir `AIService` sınıfına her şeyi koymak; feature bazlı ayır
- **Business logic UI'da** — Flutter widget içinde doğrudan API çağrısı; repository pattern kullan
- **Hardcoded model listesi** — modeller config/veritabanından gelmeli; UI kodu değişmeden yeni model eklenebilmeli
- **Senkron AI çağrısı** — async/await ile bloklamak yerine stream-first yaklaşım
- **Kota kontrolü sadece frontend'de** — backend'de de enforce edilmeli

---

## Nice-to-Have (diferansiasyon)

- **Plugin mimarisi** — kullanıcılar kendi "AI rol" şablonlarını ekleyebilsin (community marketplace)
- **LangGraph entegrasyonu** — karmaşık AI workflow'ları için (döngüsel tur, conditional branching)
- **A/B test altyapısı** — farklı prompt stratejileri test et, hangi tur sırası daha iyi sonuç verir
- **Offline-first** — Supabase Realtime + yerel SQLite cache; bağlantı kesilse oturum kaybolmasın
- **Monorepo yapısı** — Flutter + backend + shared types tek repoda; Melos ile yönet
- **CI/CD pipeline** — GitHub Actions; Flutter build + test + deploy (Vercel web, App Store mobil)
- **OpenTelemetry** — her AI turunu trace et; hangi model ne kadar sürdü, cost breakdown

---

## Referanslar

- [LangGraph Multi-Agent Orchestration 2025](https://latenode.com/blog/ai-frameworks-technical-infrastructure/langgraph-multi-agent-orchestration/)
- [OpenRouter Architecture Docs](https://openrouter.ai/docs/api/reference/limits)
- [Supabase vs Firebase for Startups 2025](https://www.leanware.co/insights/supabase-vs-firebase-complete-comparison-guide)
- [Flutter vs React Native 2025 Benchmark](https://www.synergyboat.com/blog/flutter-vs-react-native-vs-native-performance-benchmark-2025)
- [Flutter Web Production-Ready 2025](https://www.milanmeurrens.com/guides/when-to-use-flutter-for-web-in-2025-a-comprehensive-guide)
- [OpenRouter Rate Limits & Cost](https://openrouter.zendesk.com/hc/en-us/articles/39501163636379-OpenRouter-Rate-Limits-What-You-Need-to-Know)
- [Sequential AI Pipeline Patterns — LangChain](https://www.intuz.com/blog/building-multi-ai-agent-workflows-with-langchain)
