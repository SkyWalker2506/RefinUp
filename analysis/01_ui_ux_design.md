# UI/UX & Design Analiz Raporu
> Lead: A9 ArtLead | Worker: B3 Frontend Coder + D1 UI/UX Researcher | Model: Sonnet | Tarih: 2026-04-06

---

## Mevcut Durum

- Proje yeni/boş: kod yok, wireframe yok, design system yok
- Puan: **1/10** (sadece konsept var; puan potansiyele işaret eder, boşluğa değil)

---

## Kritik Eksikler (hemen yapılmalı)

| # | Sorun | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Design system tanımlı değil (token, renk, tipografi, spacing yok) | High | shadcn_flutter veya Flutter Material 3 temelinde design token sistemi kur | M |
| 2 | Multi-step AI akışı için kullanıcı mental modeli belirsiz | High | Fikir → Tur 1 → Tur 2 → ... → Sonuç aşamalarını gösteren step indicator + progress bar tasarımı | S |
| 3 | Cross-platform responsive davranış tanımlı değil | High | Web / Mobil / Desktop için breakpoint stratejisi ve layout grid belirle | M |
| 4 | Loading/streaming state tasarımı yok | High | Her AI modelinin yanıt üretirken streaming animasyonu (pulse, typing indicator, skeleton) tanımla | S |
| 5 | Boş durum (empty state) ve hata durumu tasarımı yok | Med | AI timeout, model hatası, boş sonuç için ayrı UX pattern belirle | S |

---

## İyileştirme Önerileri (planlı)

| # | Öneri | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Karşılaştırmalı görünüm (diff view) — turlar arası fikir evrimini göster | High | Side-by-side veya timeline layout; her turun katkısını highlight et | L |
| 2 | Persona/rol seçici UI — AI rollerini (eleştirmen, iyimser vb.) görsel ikonlarla sun | Med | Chip/tag bileşeni; sürükle-bırak sıralama ile tur dizisi oluşturma | M |
| 3 | Freemium sınır göstergesi — kalan tur sayısını non-intrusive göster | Med | Progress bar + soft paywall modal (abrupt değil, context'te) | S |
| 4 | Dark mode first tasarım | Med | Design token'ları dark/light ikili olarak tanımla; varsayılan dark | S |
| 5 | Mobil için swipeable tur kartları | Med | Horizontal scroll card stack; web'de grid | M |
| 6 | Sonuç export UX — kopyala, paylaş, PDF | Med | Floating action button + sheet menü | S |

---

## Kesin Olmalı (industry standard)

- **Step indicator / progress stepper:** Multi-step AI akışlarında kullanıcı nerede olduğunu her an görmeli. Perplexity, ChatGPT ve Notion AI'ın hepsi adım bazlı yanıt akışı kullanıyor.
- **Streaming / progressive rendering:** AI yanıtları token token gelirken ekranda gösterilmeli; kullanıcı boş ekranda beklememeli. 2025 itibarıyla bu tüm AI arayüzlerde standart.
- **Undo / edit tur:** Kullanıcı önceki tura dönebilmeli veya prompt'u düzenleyebilmeli; geri alınamaz akış UX anti-pattern.
- **Micro-interaction feedback:** Her tur tamamlandığında animasyonlu bir "tamamlandı" sinyali — kullanıcı belirsizlikte kalmamalı.
- **Responsive layout:** Flutter'ın adaptive layout API'si ile Web/Tablet/Mobil'de aynı component farklı layout'ta çalışmalı.

---

## Kesin Değişmeli (mevcut sorunlar)

*Henüz kod olmadığı için "mevcut" sorunlar konsept seviyesindedir:*

- **"Sonuçta en güçlü versiyon özeti" konsepti** — bu özellik tek başına karmaşık bir UX kararı. "En güçlü" kimin kararı? Algoritmik mı, kullanıcı oylaması mı, AI seçimi mi? Belirsiz bırakılırsa kullanıcıya arbitrary hissettirilen bir sonuç sunar.
- **"Kullanıcı tur sayısını özelleştirebilir"** — bu ayar ne zaman, nerede yapılır? Akış başlamadan önce mi yoksa sırasında mı? Akış başladıktan sonra değiştirilebilir mi? Bu UX kritik path karar.

---

## Nice-to-Have (diferansiasyon)

- **Tur replay animasyonu:** Fikrin turdan tura nasıl evrildiğini "film şeridi" gibi gösteren animated timeline
- **Community templates:** Popüler AI rol dizileri (örn: "Startup Validator", "Devil's Advocate Chain") — kullanıcı paylaşır, topluluk kullanır
- **Inline annotation:** Kullanıcı AI çıktısının belirli paragraflarını pin'leyerek "bunu koru" / "bunu sorgula" işaretleyebilir
- **Ses özeti (TTS):** Olgunlaşmış fikrin sesli özeti; yüksek erişilebilirlik + diferansiasyon değeri

---

## Referanslar

- [7 New Rules of AI in UX Design for 2026 — Millipixels](https://millipixels.com/blog/ai-in-ux-design)
- [UX Challenges When AI Is Part of the Core Workflow — AlterSquare](https://altersquare.io/ux-challenges-ai-core-workflow/)
- [shadcn_flutter Flutter package](https://pub.dev/packages/shadcn_flutter)
- [Multi-Platform Design Systems — dbanks.design](https://dbanks.design/blog/multi-platform/)
- [How AI Is Transforming UX Design — UXmatters](https://www.uxmatters.com/mt/archives/2025/11/how-ai-is-transforming-ux-design-and-product-experience-planning-in-2025.php)
