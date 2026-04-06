# #2 Performance & Core Web Vitals Analiz Raporu

> Lead: A10 CodeLead | Worker: B12 Performance Optimizer | Model: Sonnet | Tarih: 2026-04-06

---

## Mevcut Durum

- Proje yeni/boş: kod yok, mimari seçimleri henüz yapılmamış
- Performans kararları bu aşamada alınmalı — sonradan düzeltmek maliyetlidir
- **Puan: N/A** (kod yok; ancak mimari seçimlere göre başlangıç skoru 4-8/10 arasında değişir)

---

## Kritik Eksikler (hemen yapılmalı)

| # | Sorun | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | AI yanıt streaming mimarisi tanımlanmamış — polling kullanılırsa UX çöker | High | SSE (Server-Sent Events) ile streaming pipeline kur; her AI turunu chunk chunk aktar | M |
| 2 | Sequential AI pipeline bloklu çalışırsa toplam süre N*T olur (kullanıcı bekler) | High | Her AI turu biter bitmez kısmi sonucu stream et; kullanıcı beklemeden okusun | M |
| 3 | Flutter Web'in ilk yükleme süresi (LCP) varsayılan ayarlarla kötü — Core Web Vitals başarısız | High | WASM renderer kullan, deferred loading, code splitting, splash screen | S |
| 4 | OpenRouter API çağrıları için timeout/retry stratejisi yok | High | Exponential backoff, 30s timeout, kullanıcıya hata mesajı + devam seçeneği | S |

---

## İyileştirme Önerileri (planlı)

| # | Öneri | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Her AI turunu önbelleğe al — aynı giriş + model kombinasyonu için tekrar API çağrısı yapma | Med | Redis/Firestore cache; hash(prompt+model) → sonuç | M |
| 2 | Flutter isolate kullanımı — ağır JSON parsing UI thread'ini bloklamasın | Med | `compute()` ile ayrıştırma; heavy list rendering için `ListView.builder` | S |
| 3 | Sonuç ekranında markdown render performansı — büyük AI çıktıları Flutter'da yavaşlar | Med | Paginated rendering, virtual scroll, lazy markdown parse | M |
| 4 | Web için Progressive Web App (PWA) desteği — offline cache, install prompt | Med | Flutter PWA manifest + service worker; önceki oturumları offline göster | M |
| 5 | Mobil için görsel boyutları optimize et — AI sonuç paylaşım kartları | Low | flutter_image_compress; WebP format; lazy load | S |

---

## Kesin Olmalı (industry standard)

- **SSE streaming** — LLM yanıtları chunk chunk akmalı, kullanıcı "düşünüyor" değil içerik görmelidir
- **Skeleton loading** — her AI turu başlarken içerik placeholder'ları göster
- **Flutter WASM renderer** — web performansı için zorunlu (Flutter 3.22+)
- **API timeout + retry** — OpenRouter veya model sağlayıcı gecikmelerine karşı koruma
- **Lazy route loading** — Flutter'da sayfa bazlı deferred import
- **Core Web Vitals hedefleri:** LCP < 2.5s, FID < 100ms, CLS < 0.1 (web için)

---

## Kesin Değişmeli (mevcut sorunlar)

Proje henüz kod yok. Ancak şu kaçınılması gereken anti-pattern'ler:

- `FutureBuilder` içinde `FutureBuilder` zincirleme → state management library kullan (Riverpod/Bloc)
- AI yanıtı geldikçe `setState` ile tüm widget'ı rebuild etme → `ValueNotifier` veya stream ile fine-grained update
- `http.get()` ile polling → SSE veya WebSocket ile push-based streaming
- Tüm AI turlarını tek seferde göster → aşamalı akış, her tur kendi section'ında

---

## Nice-to-Have (diferansiasyon)

- **Token-level streaming** — her kelime geldikçe ekranda görünsün (ChatGPT efekti); kullanıcı algısında latency düşer
- **Tur süresi göstergesi** — "Bu model genellikle 8-12 saniyede yanıtlar" gibi beklenti yönetimi
- **Background processing** — uygulama minimize edilince tur devam etsin, bildirim at
- **Bandwidth adaptive** — yavaş bağlantıda daha az model çalıştır, kullanıcıya sor
- **Edge function deployment** — Vercel/Cloudflare Edge'de AI proxy; Türkiye'den erişim latency'si düşer

---

## Referanslar

- [SSE for LLM Streaming — Procedure Tech](https://procedure.tech/blogs/the-streaming-backbone-of-llms-why-server-sent-events-(sse)-still-wins-in-2025)
- [Flutter Web in 2025 — Medium](https://medium.com/@alaxhenry0121/flutter-web-in-2025-the-cross-platform-promise-vs-reality-2d417a5cabc5)
- [Flutter WASM & Core Web Vitals — dasroot.net](https://dasroot.net/posts/2026/04/flutter-web-building-progressive-web-apps/)
- [Mobile App Performance & Core Web Vitals Guide](https://quashbugs.com/blog/mobile-app-performance-core-web-vitals)
- [OpenRouter Rate Limits](https://openrouter.zendesk.com/hc/en-us/articles/39501163636379-OpenRouter-Rate-Limits-What-You-Need-to-Know)
