# Accessibility Analiz Raporu
> Lead: A9 ArtLead | Worker: D8 Mockup Reviewer | Model: Haiku | Tarih: 2026-04-06

---

## Mevcut Durum

- Proje yeni/boş: erişilebilirlik altyapısı, test stratejisi, WCAG hedefi tanımlı değil
- Flutter seçimi erişilebilirlik açısından orta-iyi başlangıç noktası (semantics API mevcut)
- Puan: **1/10** (boş proje; en erken aşamada a11y kararları kritik önem taşır)

---

## Kritik Eksikler (hemen yapılmalı)

| # | Sorun | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | WCAG hedef seviyesi belirlenmemiş | High | Minimum WCAG 2.1 AA hedefle — tüm ekip bu kararı baştan bilmeli | S |
| 2 | AI çıktısı için alt text / semantik yapı stratejisi yok | High | AI'ın ürettiği markdown/rich text içerik screen reader'da düzgün okunmalı; heading hiyerarşisi, listeler semantik olmalı | M |
| 3 | Klavye navigasyonu planlanmadı | High | Flutter'da FocusNode + FocusTraversalGroup ile tüm akış klavyeyle tamamlanabilmeli; tur başlatma, sonuç okuma, export | M |
| 4 | Renk kontrastı tasarım kararlarına dahil edilmedi | High | Design token tanımlarken WCAG 1.4.3 (4.5:1 metin, 3:1 UI element) zorunluluğunu baştan uygula | S |
| 5 | Streaming/animasyon erişilebilirliği düşünülmedi | Med | "Prefers-reduced-motion" medya sorgusuna göre animasyonları kapat; streaming pulse animasyonu için alternatif durum göstergesi | S |

---

## İyileştirme Önerileri (planlı)

| # | Öneri | Etki | Çözüm | Efor |
|---|-------|------|-------|------|
| 1 | AI çıktısı "okuma seviyesi" kontrolü (WCAG 3.1.5) | Med | AI modellerine prompt'ta "plain language" direktifi ver; uzun karmaşık cümleleri flagle | M |
| 2 | Tur ilerleyişi için sesli duyuru (live region) | Med | Flutter Semantics liveRegion ile "Tur 2 tamamlandı, AI-2 yanıtı hazır" duyurusu | S |
| 3 | Freemium modal/paywall erişilebilirliği | Med | Modal açıldığında focus trap doğru çalışmalı; ESC ile kapanmalı; screen reader "modal açıldı" duyurmalı | S |
| 4 | Renk körü dostu tasarım | Med | Turları renk dışında şekil/ikon ile de ayırt et; "AI-1 = mavi" değil, "AI-1 = beyin ikonu + mavi" | S |
| 5 | Touch target boyutları | Med | Mobil'de minimum 44x44px tıklanabilir alan (WCAG 2.5.5); küçük ikonlara padding ekle | S |
| 6 | Otomatik a11y testi CI pipeline'a ekle | Low | flutter_test + accessibility_tools paket ile her build'de temel kontroller | M |

---

## Kesin Olmalı (industry standard)

- **Flutter Semantics API kullanımı:** Her custom widget için `Semantics` widget'ı ile label, hint, role tanımla. Flutter default bileşenler genellikle erişilebilir; custom olanlar değil.
- **Dinamik içerik duyuruları:** AI çıktısı geldiğinde, tur tamamlandığında — ekran değişikliklerini screen reader kullanıcısına `SemanticsService.announce()` ile bildir.
- **Link metni anlamlı olmalı:** "Buraya tıkla" veya "Daha fazla" değil; "Tur 3 sonucunu görüntüle", "GPT-4 çıktısını kopyala" gibi açıklayıcı metinler.
- **Form erişilebilirliği:** Fikir giriş alanı için label (placeholder yeterli değil), hata mesajları ARIA-live ile duyurulmalı.
- **Test: VoiceOver (iOS) + TalkBack (Android) + NVDA (Web):** Her platform için gerçek screen reader testi — otomasyon tam kapsamı sağlamaz.

---

## Kesin Değişmeli (mevcut sorunlar)

*Konsept seviyesinde öngörülen a11y riskleri:*

- **Karşılaştırmalı görünüm (diff/side-by-side)** — çok sütunlu karmaşık layout'lar screen reader için en kötü deneyimi üretir. Bu özellik eklenirse özellikle a11y dostu bir linearized okuma modu sunulmalı.
- **"Turlar arası fikir evrimi" animasyonu** — görsel-ağırlıklı bir deneyim planlanıyor. Görme engelli kullanıcı için aynı bilginin metinsel alternatifi zorunlu. "Tur 1'de X vurgulandı, Tur 2'de Y eklendi" gibi bir özet metin eşliği gerekli.
- **AI rol ikonları** — eğer roller yalnızca ikonla ifade edilirse (renk + şekil), screen reader hiçbir şey okuyamaz. Her ikonun `semanticsLabel`'i olmalı.

---

## Nice-to-Have (diferansiasyon)

- **Yüksek kontrast modu:** Sistem düzeyinde yüksek kontrast aktifken RefinUp buna uyum sağlamalı — ek design token seti
- **Metin boyutu ölçeklendirme:** Sistem font boyutu büyütüldüğünde layout bozulmamalı; Flutter `textScaleFactor` ile test et
- **TTS entegrasyonu (1. sınıf özellik):** AI çıktısını oku butonu — hem a11y hem diferansiasyon. Özellikle mobil'de yüksek değer
- **Çok dilli erişilebilirlik:** Screen reader dil etiketleri, farklı dillerdeki AI çıktıları için `lang` attribute

---

## Referanslar

- [How WCAG Guidelines Apply to AI-Generated Content — AudioEye](https://www.audioeye.com/post/wcag-guidelines-ai-generated-content/)
- [WCAG Applies to AI-Generated Content — 216digital](https://216digital.com/how-wcag-applies-to-ai-generated-content/)
- [Accessibility in UI/UX Design 2025 Best Practices — Orbix](https://www.orbix.studio/blogs/accessibility-uiux-design-best-practices-2025)
- [AI and Accessibility — Mass.gov](https://www.mass.gov/info-details/artificial-intelligence-ai-and-accessibility)
- [WCAG 2.1 Official Guidelines — W3C](https://www.w3.org/TR/WCAG21/)
