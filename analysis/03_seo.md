# SEO & Discoverability Analiz Raporu
> Lead: A11 GrowthLead | Worker: H5 SEO Agent | Model: Haiku | Tarih: 2026-04-06

---

## Mevcut Durum

- Proje yeni/boş: hiç kod yok, domain/deployment yok, içerik yok
- Teknik SEO altyapısı: sıfır
- Organik varlık: sıfır
- Puan: **1/10** (yalnızca fikir puanı; sıfır uygulama)

---

## Kritik Eksikler (hemen yapılmalı)

| # | Sorun | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Domain + hosting yok, Google indekslenemez | High | Domain al, Vercel/Netlify'a deploy et | S |
| 2 | `robots.txt` ve `sitemap.xml` yok | High | Otomatik sitemap üret (next-sitemap veya benzer) | S |
| 3 | Structured data (JSON-LD) yok | High | `SoftwareApplication` + `WebApplication` schema ekle | M |
| 4 | `<meta>` ve Open Graph etiketleri yok | High | Sayfa bazlı title/description/OG/Twitter Card | M |
| 5 | Core Web Vitals optimize edilmedi | High | LCP < 2.5s, CLS < 0.1 hedefi — SSR/SSG seç | M |
| 6 | HTTPS / canonical URL politikası yok | Med | `www` vs `non-www` karar ver, canonical ekle | S |

---

## İyileştirme Önerileri (planlı)

| # | Öneri | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | Landing page SEO: "multi-AI idea refinement" anahtar kelimesi için optimize sayfa | High | Blog + landing kombinasyonu, intent-match content | M |
| 2 | GEO (Generative Engine Optimization): LLM'lerin siteyi cite etmesi için yapılandırılmış içerik | High | Heading + liste + SSS formatı, intro'ya anahtar bilgiyi koy | M |
| 3 | Programatik içerik: "X fikri nasıl geliştirilir" tarzı binlerce sayfa | High | Template + AI-generated topic pages (ör: "startup fikri refinement") | L |
| 4 | Backlink: Product Hunt, Hacker News, Indie Hackers launch | High | Launch stratejisi planla, erken launch için beta kullanıcı topla | M |
| 5 | FAQ schema: "multi-AI nedir", "AI fikir geliştirme nasıl çalışır" | Med | FAQPage JSON-LD ekle | S |
| 6 | Blog: AI araçları karşılaştırma içerikleri (GPT vs Gemini vs Claude) | High | Haftalık içerik takvimi, comparison pages | L |
| 7 | Perplexity/ChatGPT görünürlüğü için Wikipedia benzeri kaynaklara atıf ve citation alma | Med | Guest post, PR çalışması, directory listing | L |
| 8 | Çok dilli SEO: TR + EN minimum, önce EN | Med | i18n routing, EN'e öncelik ver | M |

---

## Kesin Olmalı (industry standard)

- `sitemap.xml` + `robots.txt` — her web projesinde zorunlu
- Her sayfa için benzersiz `<title>` (≤60 karakter) ve `<meta description>` (≤160 karakter)
- Open Graph + Twitter Card meta etiketleri (sosyal paylaşım önizlemesi için kritik)
- HTTPS + canonical URL
- Mobile-first responsive tasarım (Google mobile-first indexing kullanıyor)
- Sayfa yükleme hızı: LCP < 2.5s (Core Web Vitals)
- `SoftwareApplication` JSON-LD structured data
- Google Search Console + Bing Webmaster Tools kaydı
- 404 sayfası ve redirect politikası

---

## Kesin Değişmeli (mevcut sorunlar)

- Şu an hiçbir şey yok — başlanmadan inşa edilmeli. "Sonradan eklerim" değil, ilk deploy'dan itibaren temel SEO altyapısı kurulmalı.
- Araştırma bulgusu: LLM referrerlardan gelen kullanıcılar organik arama kullanıcılarından **4.4x daha yüksek** dönüşüm sağlıyor — GEO ihmal edilemez.

---

## Nice-to-Have (diferansiasyon)

- **Shareable output pages**: Kullanıcının rafine edilmiş fikirlerini `/idea/[id]` formatında public URL ile paylaşabilmesi → her paylaşım yeni bir indexed sayfa olur (UGC SEO)
- **Topical authority**: "AI ile fikir geliştirme" nişinde lider olmak için 50+ derinlikli blog yazısı
- **Programatik SEO**: Kullanım alanı × AI model kombinasyonu sayfaları (ör: "Girişim Fikirlerini Gemini ile Geliştir")
- **AI citations**: Perplexity ve ChatGPT'nin siteyi kaynak olarak göstermesi için structured data + yüksek kaliteli içerik
- **Video SEO**: YouTube'da "AI ile fikir geliştirme" içerikleri (Perplexity YouTube kaynaklarını tercih ediyor)

---

## Referanslar

- [90+ AI SEO Statistics for 2025](https://www.position.digital/blog/ai-seo-statistics/)
- [AI Search Optimization 2025: ChatGPT SEO Strategies Guide](https://www.getpassionfruit.com/blog/how-to-show-up-your-content-on-chat-gpt-and-perplexity)
- [SEO For Perplexity AI: Get More Visibility](https://www.brainz.digital/blog/seo-for-perplexity/)
- [The Evolution of Search in 2025: What AI Means for SEO](https://www.concordusa.com/blog/the-evolution-of-search-in-2025-what-ai-means-for-seo)
