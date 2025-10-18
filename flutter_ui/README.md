# Aether Desktop - Flutter UI

Aether P2P File Sync için Flutter masaüstü uygulaması.

## Özellikler

- ✨ Modern ve kullanıcı dostu arayüz
- 🌓 Light ve Dark tema desteği
- 📁 Klasör yönetimi
- 🔄 Gerçek zamanlı senkronizasyon durumu
- 👥 Peer/Cihaz yönetimi
- ⚙️ Kapsamlı ayarlar
- 📊 Aktivite geçmişi

## Gereksinimler

- Flutter SDK 3.16+
- Dart SDK 3.0+
- Windows / macOS / Linux

## Kurulum

```bash
# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır (Windows)
flutter run -d windows

# Uygulamayı çalıştır (macOS)
flutter run -d macos

# Uygulamayı çalıştır (Linux)
flutter run -d linux
```

## Proje Yapısı

```
lib/
├── core/
│   ├── theme/           # Tema tanımları
│   ├── constants/       # Sabitler
│   └── utils/           # Yardımcı fonksiyonlar
├── features/
│   ├── home/           # Ana sayfa
│   ├── folders/        # Klasör yönetimi
│   ├── devices/        # Cihaz yönetimi
│   ├── sync/           # Senkronizasyon
│   └── settings/       # Ayarlar
├── data/
│   ├── models/         # Data modelleri
│   ├── providers/      # Riverpod providers
│   └── services/       # gRPC servisleri
└── main.dart
```

## gRPC Entegrasyonu

gRPC client kodları şu şekilde generate edilecek:

```bash
# Proto dosyalarını compile et
protoc --dart_out=grpc:lib/generated -I../api/proto ../api/proto/*.proto
```

## State Management

Proje Riverpod kullanmaktadır:

```dart
// Provider örneği
final foldersProvider = StateNotifierProvider<FoldersNotifier, List<Folder>>((ref) {
  return FoldersNotifier(ref.read(grpcServiceProvider));
});
```

## Tema

Uygulama Material 3 tasarım sistemi kullanır:

- **Primary Color**: Indigo (#6366F1)
- **Secondary Color**: Purple (#8B5CF6)
- **Typography**: Inter font family

## Geliştirme

```bash
# Hot reload ile geliştirme
flutter run -d windows --hot

# Build (release)
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## Katkıda Bulunma

Lütfen CONTRIBUTING.md dosyasını okuyun.

## Lisans

MIT License





