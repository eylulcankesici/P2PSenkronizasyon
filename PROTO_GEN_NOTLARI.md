# Proto Dosyalarını Generate Etme Notları

## Flutter için Proto Generate Etme

Proto dosyaları Flutter için generate edilmediği için şu an kodlar çalışmıyor.

### Gereksinimler:
1. `protoc` komutu PATH'te olmalı
2. `protoc-gen-dart` plugin'i yüklü olmalı

### Kurulum (PowerShell):
```powershell
# Dart pub cache'e protoc-gen-dart plugin'ini yükle
dart pub global activate protoc_plugin

# PATH'e ekle (otomatik olmayabilir)
$env:PATH += ";$env:USERPROFILE\.pub-cache\bin"
```

### Generate Etme:
```powershell
# Flutter için proto dosyalarını generate et
protoc --dart_out=grpc:flutter_ui/lib/generated -I. -Ithird_party -Iapi/proto api/proto/peer.proto api/proto/common.proto
```

### Gerekli Proto Dosyaları:
- `api/proto/common.proto`
- `api/proto/peer.proto`

### Generate Edildikten Sonra:
1. `flutter_ui/lib/generated/api/proto/peer.pbgrpc.dart` dosyasında şu metodlar olmalı:
   - `createInvitation`
   - `addPeerByInvitation`
   - `exchangeSDP`

2. `flutter_ui/lib/generated/api/proto/peer.pb.dart` dosyasında şu class'lar olmalı:
   - `CreateInvitationRequest`
   - `CreateInvitationResponse`
   - `AddPeerByInvitationRequest`
   - `ExchangeSDPRequest`
   - `ExchangeSDPResponse`
   - `DiscoverPeersRequest.wanOnly` field'ı

3. Kod içindeki `TODO` comment'leri kaldırılmalı ve gerçek type'lar kullanılmalı.

