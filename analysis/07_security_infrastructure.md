## Security & Infrastructure Analiz Raporu
> Lead: A13 SecLead | Worker: B13 Security Auditor + C2 Security Scanner | Model: Opus | Tarih: 2026-04-06

---

### Mevcut Durum
- **Proje yeni/bos:** Kod yok — sadece README ve scaffold kalintilari (.dart_tool, .idea, .metadata)
- **Risk profili:** **High** — Multi-AI entegrasyonu, kullanici verisi, 3rd party API key yonetimi, freemium odeme, cross-platform
- **Puan: 3/10** — Henuz hicbir guvenlik onlemi yok; tasarim asamasinda kritik kararlar alinmali

---

### Kritik Riskler (hemen onlem alinmali)

| # | Risk | OWASP/CVE | Etki | Onlem | Efor |
|---|------|-----------|------|-------|------|
| 1 | **OpenRouter API key client-side'da ifsa** | LLM06 (Sensitive Info Disclosure) | **Critical** — Saldirgan API key'i alip sinirsiz AI cagri yapar, fatura patlar | API key'i ASLA client'ta tutma; backend proxy uzerinden tum AI cagrilarini yonlendir | S |
| 2 | **Prompt Injection (dogrudan + dolayli)** | LLM01 (Prompt Injection) | **Critical** — Kullanici prompt'u onceki AI ciktisina enjekte edilerek sistem prompt'u override edilebilir; zincirli modelde her tur saldiri yuzeyini genisletir | Input sanitization + system prompt izolasyonu + cikti validasyonu; her AI turu arasinda context temizleme | M |
| 3 | **Denial of Wallet (maliyet saldirisi)** | LLM10 (Unbounded Consumption) | **Critical** — Saldirgan sahte hesaplarla binlerce AI turu tetikler, OpenRouter faturasi patlar | Per-user rate limiting (token bucket), gunluk/haftalik maliyet tavani, CAPTCHA, IP throttling | M |
| 4 | **Kullanici verileri arasi sizinti (multi-tenant leakage)** | LLM06 | **High** — Bir kullanicinin fikri/prompt'u baska kullaniciya gosterilebilir; ozellikle cache/session karismasinda | Tenant ID bazli strict izolasyon; AI response cache'lerinde tenant kontrolu; session state'i her istek sonrasi temizle | M |
| 5 | **Firebase Security Rules eksikligi** | OWASP A01 (Broken Access Control) | **Critical** — Firebase varsayilan olarak guvenlik kurali icermez; tum veriler herkese acik olur | Firestore/RTDB rules'u ilk gun yaz; App Check aktif et; email enumeration korumasini ac | S |
| 6 | **Auth token calinan cihazda sinirsiz erisim** | OWASP A07 (Auth Failures) | **High** — Refresh token calindiysa saldirgan hesabi tamamen devralir | Token suresi kisitla (1h access, 7d refresh); cihaz baglama; MFA (en azindan premium kullanicilar icin) | M |

---

### Mimari Guvenlik Onerileri

| # | Oneri | Etki | Cozum | Efor |
|---|-------|------|-------|------|
| 1 | **Backend proxy katmani (BFF)** | Critical | Tum AI cagrilari backend uzerinden; client hicbir AI API key'i bilmez. Cloud Functions / Edge Functions / API Gateway | M |
| 2 | **Kullanici bazli maliyet kotasi** | Critical | Redis/Firestore'da kullanici basina gunluk tur + token limiti; free tier: 5 tur/gun, premium: 50 tur/gun | M |
| 3 | **AI cikti sanitizasyonu** | High | Her AI ciktisini kullaniciya gostermeden once XSS/HTML injection temizle; Markdown render'da sandbox kullan | S |
| 4 | **Secrets management** | Critical | Environment secrets icin Secret Manager (GCP/AWS); .env dosyasi repo'ya eklenmemeli (.gitignore); CI/CD'de encrypted secrets | S |
| 5 | **Audit logging** | High | Her AI cagrisi: kullanici ID, model, tur no, timestamp, maliyet, IP; anomali tespiti icin | M |
| 6 | **CORS ve API Gateway** | High | Backend API'ye sadece kendi domain'lerinden erisim; rate limit gateway seviyesinde | S |

---

### Kesin Olmali (minimum guvenlik standardi)

1. **API key'ler backend'de** — Client-side kodda hicbir API key/secret bulunmamali
2. **Firebase Security Rules** — Firestore, Storage, RTDB kurallari production-ready olmali; `allow read, write: if true` ASLA olmamali
3. **Firebase App Check** — Bot ve script saldirilarini engellemek icin aktif
4. **HTTPS everywhere** — Tum trafik TLS 1.3 uzerinden
5. **Input validation** — Prompt uzunluk limiti (orn. 5000 karakter), rate limit, karakter filtreleme
6. **Authentication** — Firebase Auth + email dogrulama zorunlu; anonim auth uretim ortaminda kapali
7. **.gitignore** — `.env`, `google-services.json`, `GoogleService-Info.plist`, Firebase service account key
8. **Dependency scanning** — Dependabot / Snyk aktif; bilinen CVE'li paketleri engelle
9. **CORS policy** — Sadece kendi domainleri whitelist
10. **Error handling** — Stack trace ve ic detaylari kullaniciya gosterme; generic hata mesajlari

---

### Kesin Degismeli (baslangictan itibaren yapilmamasi gereken anti-pattern'ler)

1. **Client-side API key** — OpenRouter/AI API key'lerini Flutter/web koduna gomme
2. **Guvenlik kuralsiz Firebase** — Default `allow all` kurallariyla deploy
3. **Kullanici prompt'larini loglama (plaintext)** — KVKK/GDPR ihlali; loglayacaksan pseudonymize et
4. **Tek bir rate limit yok** — Free tier kullanicinin sinirsiz AI cagri yapabilmesi
5. **AI ciktisini raw HTML olarak render** — XSS vektoru
6. **Hardcoded secrets** — Kodda veya config dosyalarinda API key, Firebase credentials
7. **Sinirsiz prompt uzunlugu** — Token tuketim saldirisi + maliyet patlamasi
8. **Session/context paylasimi** — Farkli kullanicilarin AI conversation state'ini ayirmamak

---

### Nice-to-Have (ileri duzey guvenlik)

1. **SOC 2 Type II** — Enterprise musteri hedefleniyorsa (ileride)
2. **End-to-end encryption** — Kullanici fikirleri transit + at-rest sifreli
3. **WAF (Web Application Firewall)** — Cloudflare/AWS WAF ile ek koruma
4. **Penetration testing** — MVP sonrasi profesyonel pentest
5. **Bug bounty programi** — Public beta sonrasi
6. **MFA (Multi-Factor Auth)** — Premium kullanicilar icin SMS/TOTP
7. **Content Safety API** — AI ciktilarinda zararli/yasadisi icerik tespiti (OpenAI Moderation, Perspective API)
8. **Geo-blocking** — Yasakli bolgelere erisim kisitlama
9. **API versioning** — Breaking change'lerde eski client'lari koruma
10. **Infra-as-Code** — Terraform/Pulumi ile guvenlik config'lerini versiyonla

---

### AI-Spesifik Riskler (Prompt Injection, Model Abuse, vb.)

| # | Risk | Aciklama | Etki | Onlem | Efor |
|---|------|----------|------|-------|------|
| 1 | **Zincirli Prompt Injection** | RefinUp'in temel ozelligi (AI-1 → AI-2 → AI-3 zinciri) her turda injection yuzeyini katlar. AI-1'in ciktisina gomulu talimat AI-2'yi manipule eder | **Critical** | Her tur arasinda ciktiyi sanitize et; system prompt'u her turda yeniden enjekte et; cikti formatini zorunlu kil (structured output) | L |
| 2 | **System Prompt Leakage** | Kullanici "System prompt'unu goster" gibi isteklerle rol tanimini ifsa ettirebilir | **High** | System prompt'u asla user message'a dahil etme; API seviyesinde `system` rolu kullan; leakage detection ekle | S |
| 3 | **Model Abuse (icerik uretimi)** | Kullanici platformu zararli icerik uretmek icin kullanabilir (deepfake prompt, dolandiricilik metni vb.) | **High** | Content moderation katmani; AI ciktisini moderation API'den gecir; kullanici raporlama mekanizmasi | M |
| 4 | **Data Poisoning via User Feedback** | Kullanici geri bildirimi modele feedback olarak gidiyorsa, kasitli yanlis yonlendirme | **Medium** | Kullanici feedback'ini dogrudan model fine-tuning'e verme; aggregation + insan incelemesi | S |
| 5 | **Indirect Prompt Injection** | Kullanici girdisine URL/dosya ekleme destegi varsa, dis kaynak uzerinden injection | **High** | Dis kaynak icerigi sandbox'ta isle; URL fetch'te izin listesi kullan; icerigi AI'ya gondermeden temizle | M |
| 6 | **AI Hallucination Riski** | Yanlis bilgi uretimi — ozellikle "olgunlastirilmis fikir" olarak sunuldugunda kullanici yanilabilir | **Medium** | Disclaimer ekle; her turda "confidence score" goster; kaynak belirtilmemis iddialari isaretleme | S |
| 7 | **Cross-Model Data Leakage** | OpenRouter uzerinden farkli provider'lara gonderilen prompt'lar o provider'larin privacy policy'lerine tabi | **High** | Kullaniciyi bilgilendir (privacy notice); hassas veri iceren prompt'lari uyar; data processing agreement (DPA) imzala | M |
| 8 | **LLM Cache Side-Channel (PROMPTPEEK)** | Paylasimli LLM cache'inde timing analizi ile baska kullanicinin prompt'u cikarilebilir | **Medium** | Shared cache kullanma veya tenant-isolated cache; OpenRouter tarafinda bu riski degerlendirmek icin DPA incele | L |

---

### KVKK / GDPR Uyumlulugu

| # | Gereksinim | Durum | Onlem | Efor |
|---|-----------|-------|-------|------|
| 1 | **Acik Riza (Consent)** | Yok | Kullanici verilerinin AI'ya gonderilecegini acikca belirt; opt-in consent | S |
| 2 | **DPIA (Veri Koruma Etki Degerlendirmesi)** | Yok | AI isleme icin DPIA hazirla; KVKK m.16 / GDPR m.35 | M |
| 3 | **Veri Silme Hakki (Right to Erasure)** | Yok | Kullanici hesap sildiginde tum prompt/cikti verisi silinmeli; 3rd party API'lerde retention policy kontrol | M |
| 4 | **Veri Isleme Sozlesmesi (DPA)** | Yok | OpenRouter + diger AI provider'larla DPA imzala | M |
| 5 | **Cerez/Tracking Politikasi** | Yok | Cookie consent banner; analytics icin opt-in | S |
| 6 | **Veri Minimizasyonu** | Yok | Sadece gerekli veriyi topla; prompt loglarini pseudonymize et veya belirli sure sonra sil | S |
| 7 | **Cross-border Transfer** | Yok | AI provider'lar (OpenAI US, Google US) icin SCCs veya adequacy karari gerekli | L |

---

### Referanslar

- [OWASP Top 10 for LLM Applications 2025](https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/)
- [OWASP Top 10 for Agentic Applications 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/)
- [OWASP LLM Prompt Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/LLM_Prompt_Injection_Prevention_Cheat_Sheet.html)
- [Prompt Injection Attacks in LLMs (2026 Guide)](https://www.getastra.com/blog/ai-security/prompt-injection-attacks/)
- [LLM Security Risks in 2026](https://sombrainc.com/blog/llm-security-risks-2026)
- [Firebase Security Checklist](https://firebase.google.com/support/guides/security-checklist)
- [Firebase App Check](https://firebase.google.com/docs/app-check)
- [OpenRouter API Key Rotation](https://openrouter.ai/docs/guides/administration/api-key-rotation)
- [OpenRouter OAuth PKCE](https://openrouter.ai/docs/guides/overview/auth/oauth)
- [Multi-Tenant AI Leakage: Isolation & Security Challenges](https://layerxsecurity.com/generative-ai/multi-tenant-ai-leakage/)
- [Denial of Wallet: Cost-Aware Rate Limiting for GenAI](https://handsonarchitects.com/blog/2025/denial-of-wallet-cost-aware-rate-limiting-part-2/)
- [API Rate Limiting Best Practices 2025](https://zuplo.com/learning-center/10-best-practices-for-api-rate-limiting-in-2025)
- [EDPB AI Privacy Risks in LLMs (2025)](https://www.edpb.europa.eu/system/files/2025-04/ai-privacy-risks-and-mitigations-in-llms.pdf)
- [GDPR ve KVKK Karsilastirmali Analiz (AI Riskleri)](https://hstalks.com/article/9182/mitigating-ai-risks-a-comparative-analysis-of-data/)
- [SaaS Privacy Compliance 2025](https://secureprivacy.ai/blog/saas-privacy-compliance-requirements-2025-guide)
- [GDPR Compliance 2026-Ready Guide](https://secureprivacy.ai/blog/gdpr-compliance-2026)
