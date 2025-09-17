# Türkiye Diş Hastaneleri Uygulaması

Bu Flutter uygulaması, Türkiye'deki diş hastanelerini listeleyen ve detaylı bilgilerini sunan bir mobil uygulamadır.

## Özellikler

### Ana Sayfa
- Tüm diş hastanelerinin listesi
- Hastane adı, konum (il/ilçe) ve puan bilgileri
- Arama özelliği
- Manuel hastane ekleme

### İlk Tıklama (Ön İzleme)
- Seçilen hastanenin çalışan sayısını gösteren bottom sheet
- Çalışanların listesi ve rolleri

### İkinci Tıklama (Detay Sayfası)
- **Harita**: Hastanenin konumunu Google Maps üzerinde gösterir
- **Çalışanlar**: Fotoğrafları ve rolleri ile birlikte çalışan listesi
- **Yorumlar**: Hastaneye giden kullanıcıların yorumları

### Manuel Hastane Ekleme
- Hastane temel bilgileri (ad, konum, puan, iletişim)
- Çalışan ekleme (ad, rol, uzmanlık, deneyim)
- Yorum ekleme (kullanıcı, puan, yorum metni)

## Teknik Detaylar

### Kullanılan Paketler
- `google_maps_flutter`: Harita entegrasyonu
- `provider`: State management
- `shared_preferences`: Yerel veri saklama
- `http`: API çağrıları (gelecekte kullanım için)

### Proje Yapısı
```
lib/
├── models/
│   └── hospital.dart          # Veri modelleri
├── providers/
│   └── hospital_provider.dart # Veri yönetimi
├── screens/
│   ├── home_screen.dart       # Ana sayfa
│   ├── hospital_detail_screen.dart # Detay sayfası
│   └── add_hospital_screen.dart    # Hastane ekleme
├── widgets/
│   ├── hospital_card.dart     # Hastane kartı
│   ├── employee_bottom_sheet.dart # Çalışan bottom sheet
│   ├── employee_card.dart     # Çalışan kartı
│   ├── employee_list_tile.dart # Çalışan listesi
│   └── review_card.dart       # Yorum kartı
└── main.dart                  # Ana dosya
```

## Kurulum

1. Flutter SDK'yı yükleyin
2. Projeyi klonlayın
3. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
4. Google Maps API key'ini alın ve `android/app/src/main/AndroidManifest.xml` dosyasında `YOUR_GOOGLE_MAPS_API_KEY` yerine ekleyin
5. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

## Google Maps API Key

Harita özelliğini kullanabilmek için:

1. [Google Cloud Console](https://console.cloud.google.com/)'a gidin
2. Yeni proje oluşturun veya mevcut projeyi seçin
3. Maps SDK for Android'i etkinleştirin
4. API key oluşturun
5. `android/app/src/main/AndroidManifest.xml` dosyasında API key'i güncelleyin

## Veri Yapısı

### Hastane Modeli
- Temel bilgiler: ad, şehir, ilçe, adres, telefon, e-posta
- Konum: enlem, boylam
- Puan: 0-5 arası değerlendirme
- Çalışanlar: liste halinde çalışan bilgileri
- Yorumlar: kullanıcı yorumları

### Çalışan Modeli
- Ad, rol, uzmanlık alanı
- Deneyim yılı
- Fotoğraf URL'i

### Yorum Modeli
- Kullanıcı bilgileri
- Puan ve yorum metni
- Tarih ve fotoğraflar

## Gelecek Geliştirmeler

- [ ] Gerçek API entegrasyonu
- [ ] Favori hastaneler
- [ ] Randevu alma sistemi
- [ ] Push bildirimleri
- [ ] Offline mod
- [ ] Çoklu dil desteği
- [ ] Gelişmiş filtreleme

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.