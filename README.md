# 🌐 Aether - Self-Hosted P2P Dosya Senkronizasyon Aracı

<div align="center">

![Status](https://img.shields.io/badge/Status-Active%20Development-yellow)
![Go Version](https://img.shields.io/badge/Go-1.21+-00ADD8?logo=go)
![Flutter Version](https://img.shields.io/badge/Flutter-3.16+-02569B?logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green)

**Dropbox/Google Drive gibi merkezi sunuculara ihtiyaç duymadan, cihazlar arasında güvenli, uçtan uca (P2P) dosya senkronizasyonu**

</div>

---

## 🚀 Proje Hakkında

Aether, **Dropbox/Google Drive**'a alternatif olarak, merkezi sunucu gerektirmeyen, **tamamen self-hosted** ve **açık kaynaklı** bir P2P dosya senkronizasyon sistemidir.

### ✨ Temel Özellikler

- 🔒 **P2P Transfer**: Merkezi sunucu yok, doğrudan cihazlar arası transfer (LAN/WAN)
- 🧩 **Akıllı Chunk Sistemi**: Dosyaları 256 KB parçalara böl, sadece değişenleri aktar
- 🔍 **mDNS Discovery**: Aynı LAN'daki cihazları otomatik keşfet (zero-configuration)
- 🔄 **Content-Addressable Storage**: Hash-based deduplication ile disk tasarrufu
- 📊 **Versiyonlama**: Dosya geçmişi ve rollback desteği
- 👥 **Multi-Peer**: Birden fazla cihaz arasında eşzamanlı senkronizasyon
- 🎨 **Modern Flutter UI**: Çapraz platform masaüstü arayüzü
- 🏗️ **SOLID Mimari**: Temiz kod ve profesyonel tasarım prensipleri
- 🔐 **Güvenlik**: SHA-256 hash verification, bcrypt password hashing

---

## 🛠️ Teknoloji Yığını

| Bileşen | Teknoloji | Açıklama |
|---------|-----------|----------|
| **Backend Motor** | Go 1.21+ | Yüksek performanslı senkronizasyon motoru |
| **UI Framework** | Flutter 3.16+ | Çapraz platform masaüstü arayüzü |
| **API** | gRPC + Protocol Buffers | Yüksek performanslı RPC |
| **P2P Discovery** | mDNS (Bonjour) | Zero-config peer keşfi |
| **P2P Transport** | TCP + Custom Protocol | Binary frame-based communication |
| **İlişkisel DB** | SQLite | Dosya, chunk ve peer metadata |
| **Key-Value DB** | BoltDB | Konfigürasyon ve cache |
| **Chunking** | Fixed-size (256 KB) | SHA-256 hash-based deduplication |

---

## 📁 Proje Mimarisi

### Clean Architecture Katmanları

```
aether/
├── cmd/                             # Uygulama entry points
│   ├── aether-server/              # Ana Go sunucu
│   ├── test-chunking/              # Chunking sistemi test
│   ├── test-p2p-lan/               # LAN P2P test
│   └── test-p2p-e2e/               # End-to-end transfer test
│
├── internal/                        # Private Go kodu
│   ├── domain/                     # Domain Layer (Business Logic)
│   │   ├── entity/                 # Domain entities (Folder, File, Chunk, Peer)
│   │   ├── repository/             # Repository interfaces
│   │   ├── usecase/                # Use case interfaces
│   │   └── transport/              # Transport abstraction (P2P)
│   │
│   ├── usecase/impl/               # Use Case Implementations
│   │   ├── chunking_usecase_impl.go
│   │   ├── peer_discovery_usecase_impl.go
│   │   └── p2p_transfer_usecase_impl.go
│   │
│   ├── infrastructure/             # Infrastructure Layer
│   │   ├── database/
│   │   │   ├── sqlite/             # SQLite repositories
│   │   │   └── boltdb/             # BoltDB repositories
│   │   └── p2p/
│   │       └── lan/                # LAN Transport (mDNS + TCP)
│   │           ├── mdns_discovery.go
│   │           ├── tcp_connection.go
│   │           ├── protocol.go
│   │           ├── handshake.go
│   │           └── lan_transport.go
│   │
│   ├── delivery/                   # Presentation Layer
│   │   └── grpc/                   # gRPC handlers
│   │       ├── folder_handler.go
│   │       ├── file_handler.go
│   │       ├── chunk_handler.go
│   │       ├── peer_handler.go
│   │       └── p2p_handler.go
│   │
│   ├── config/                     # Configuration
│   ├── container/                  # DI Container
│   └── ...
│
├── pkg/                            # Public Reusable Packages
│   ├── chunking/                   # File chunking & storage
│   ├── reassembly/                 # File reassembly from chunks
│   ├── hashing/                    # SHA-256 hashing
│   ├── crypto/                     # Password hashing
│   └── scanner/                    # File system scanner
│
├── api/proto/                      # gRPC/Protobuf Definitions
│   ├── folder.proto
│   ├── file.proto
│   ├── chunk.proto
│   ├── peer.proto
│   ├── p2p.proto
│   └── ...
│
├── flutter_ui/                     # Flutter Desktop App
│   ├── lib/
│   │   ├── core/                   # Theme, constants
│   │   ├── features/               # Feature modules
│   │   │   └── home/               # Home screen
│   │   └── data/                   # Models, services, providers
│   └── pubspec.yaml
│
└── go.mod
```

### SOLID Prensipleri ✅

- **Single Responsibility**: Her modül tek bir sorumluluğa sahip
- **Open/Closed**: Interface-based design, WAN için kolayca genişletilebilir
- **Liskov Substitution**: TransportProvider interface her yerde kullanılabilir
- **Interface Segregation**: Discovery, Connection, Transfer ayrı
- **Dependency Inversion**: Use case'ler interface'lere bağımlı

---

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler

- **Go** 1.21 veya üstü ([İndir](https://go.dev/dl/))
- **Flutter** 3.16 veya üstü ([İndir](https://flutter.dev/docs/get-started/install))
- **Protocol Buffers Compiler** (protoc) ([İndir](https://grpc.io/docs/protoc-installation/))
- **Git** (versiyon kontrol)
- **Windows/macOS/Linux** (cross-platform)

### Hızlı Başlangıç

#### 1️⃣ Repository'yi Klonla

```bash
git clone https://github.com/yourusername/aether.git
cd aether
```

#### 2️⃣ Go Backend Kurulumu

```bash
# Go bağımlılıklarını yükle
go mod download

# Go protoc plugins'lerini yükle
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Proto dosyalarını compile et (gerekli, çünkü .pb.go dosyaları Git'e commit edilmez)
protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto

# Backend'i çalıştır
go run cmd/aether-server/main.go

# Veya PowerShell script ile (Windows)
.\start-backend.ps1
```

> **Not:** Proto dosyaları (`.pb.go`) Git'te saklanmaz. Her proje klonlamasında proto dosyalarını compile etmeniz gerekir. Bu, platform ve protoc versiyon farklarından kaynaklanan uyumsuzlukları önler.

**Backend başarıyla çalıştığında göreceğiniz log'lar:**
```
✓ SQLite bağlantısı açıldı
✓ BoltDB bağlantısı açıldı
✓ Chunking use case başlatıldı
✓ P2P Transport başlatıldı (device: Aether Node, port: 50052)
🔍 mDNS Discovery başlatılıyor...
✅ mDNS Discovery başlatıldı
✅ TCP listener başlatıldı: port 50052
🚀 gRPC sunucu dinliyor: :50051
```

#### 3️⃣ Flutter UI Kurulumu

```bash
cd flutter_ui

# Flutter bağımlılıklarını yükle
flutter pub get

# Windows için çalıştır
flutter run -d windows

# macOS için
flutter run -d macos

# Linux için
flutter run -d linux
```

---

## 📊 Veritabanı Şeması

### SQLite Tabloları (Yapısal Veri)

| Tablo | Açıklama | Önemli Alanlar |
|-------|----------|----------------|
| `folders` | Senkronize klasörler | `id`, `local_path`, `sync_mode`, `is_active` |
| `files` | Dosya metadata | `id`, `folder_id`, `relative_path`, `size`, `global_hash` |
| `chunks` | Dosya parçaları | `hash` (PK), `size`, `is_local` |
| `file_chunks` | Dosya-chunk ilişkileri | `file_id`, `chunk_hash`, `chunk_index` |
| `peers` | Ağdaki cihazlar | `device_id`, `name`, `status`, `is_trusted` |
| `users` | Kullanıcı hesapları | `id`, `username`, `password_hash` |
| `file_versions` | Dosya versiyonları | `file_id`, `version`, `global_hash` |

### BoltDB Buckets (Key-Value Config)

- **`app:`** → Instance ID, API hash
- **`network:`** → Port, discovery mode
- **`sync:`** → Last sync time, sync status

---

## 🔐 Güvenlik

### Mevcut

- ✅ **Bcrypt** ile şifre hash'leme (cost: 10)
- ✅ **SHA-256** ile dosya/chunk bütünlük kontrolü
- ✅ **Device ID** doğrulaması (TCP handshake)
- ✅ **CRC32** checksum (binary protocol)

### Planlanıyor (WAN için)

- 🔮 **TLS/DTLS** şifreleme
- 🔮 **End-to-end encryption** (chunk-level)
- 🔮 **Peer certificate verification**
- 🔮 **Replay attack protection**

---

## 📚 Kullanım

### LAN'da P2P Test

#### **İki Bilgisayarda (aynı ağda):**

**Bilgisayar A:**
```bash
go run cmd/aether-server/main.go
```

**Bilgisayar B:**
```bash
go run cmd/aether-server/main.go
```

**Test Programı (herhangi birinde):**
```bash
go run cmd/test-p2p-e2e/main.go
```

**Beklenen Çıktı:**
```
✅ P2P Transport aktif
🔍 10 saniye peer aranıyor...
📊 Bulunan peer sayısı: 1
   1. Aether Node (7f29eb76...)
🔗 Bağlanılıyor...
✅ Peer'a bağlanıldı
📥 Chunk alındı: 262144 bytes
✅ P2P sistemi hazır!
```

### Dosya Senkronizasyonu Akışı

```
1. Klasör Ekle (UI veya API)
   └─> Folder kaydı oluşturulur (SQLite)

2. Dosyaları Tara (File Scanner)
   └─> Tüm dosyalar listelenir

3. Chunk'lara Böl (Chunking Use Case)
   └─> Dosya → 256 KB chunk'lar
   └─> Her chunk SHA-256 hash alır
   └─> Disk'e kaydedilir (~/.aether/chunks/)
   └─> DB'ye kaydedilir (chunks, file_chunks)

4. Peer Keşfi (mDNS)
   └─> LAN'daki diğer Aether node'ları bulunur

5. Peer'a Bağlan (TCP + Handshake)
   └─> DeviceID doğrulaması
   └─> Persistent connection

6. Chunk Transfer
   └─> Peer chunk'ları talep eder
   └─> Binary protocol ile transfer
   └─> CRC32 checksum doğrulaması

7. Dosya Birleştir (File Reassembly)
   └─> Chunk'lar sırayla birleştirilir
   └─> Global hash doğrulanır
   └─> Disk'e yazılır
```

---

## 🧪 Testing

### Manuel Testler

```bash
# Veritabanı testi
go run cmd/test-db/main.go

# Chunking sistemi testi
go run cmd/test-chunking/main.go

# P2P LAN testi (discovery + connection)
go run cmd/test-p2p-lan/main.go

# End-to-End transfer testi
go run cmd/test-p2p-e2e/main.go

# Chunk API testi
go run cmd/test-chunk-api/main.go
```

### Build

```bash
# Proto dosyalarını compile et
protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto

# Backend build
go build -o bin/aether-server.exe cmd/aether-server/main.go

# Cross-platform build
GOOS=linux GOARCH=amd64 go build -o bin/aether-server-linux cmd/aether-server/main.go
GOOS=darwin GOARCH=amd64 go build -o bin/aether-server-macos cmd/aether-server/main.go
```

---

## 🎯 Roadmap

### ✅ Tamamlandı (v0.1)

- [x] Clean Architecture temel yapısı
- [x] SQLite ve BoltDB entegrasyonu
- [x] Repository pattern + Use case pattern
- [x] Chunking sistemi (256 KB, SHA-256)
- [x] Content-addressable storage
- [x] Deduplication
- [x] File reassembly
- [x] Versiyonlama sistemi
- [x] Flutter UI temel yapısı (klasör/dosya yönetimi)
- [x] gRPC server + handlers (tüm servisler)
- [x] **P2P LAN implementasyonu**
  - [x] mDNS discovery (_aether._tcp.local)
  - [x] TCP connection manager
  - [x] Binary protocol (frame-based)
  - [x] Handshake protokolü (DeviceID exchange)
  - [x] Chunk transfer (send/request)
  - [x] File reassembly from chunks

### 🚧 Devam Ediyor (v0.2)

- [ ] Flutter UI P2P ekranları
  - [ ] Peer listesi
  - [ ] Transfer progress bars
  - [ ] Sync status indicators
- [ ] File watcher (real-time sync)
- [ ] Conflict resolution (same file, different versions)
- [ ] Transfer retry mechanism
- [ ] Bandwidth throttling

### 🔮 Planlanıyor (v1.0)

- [ ] **WAN Support** (Wide Area Network)
  - [ ] STUN/TURN client
  - [ ] NAT traversal (hole punching)
  - [ ] WebRTC data channels
  - [ ] TLS encryption
  - [ ] Relay server fallback
- [ ] End-to-end encryption (chunk-level)
- [ ] Mobile app (iOS/Android)
- [ ] Web interface
- [ ] CLI tool

---

## 🏗️ Mimari Kararlar

### Neden P2P?

- ✅ **Gizlilik**: Verileriniz hiçbir sunucudan geçmez
- ✅ **Hız**: Aynı LAN'da 100+ MB/s transfer
- ✅ **Maliyet**: Sunucu kiralaması yok
- ✅ **Kontrol**: Tamamen size ait

### Neden Clean Architecture?

- ✅ **Test edilebilirlik**: Her katman izole test edilebilir
- ✅ **Bakım kolaylığı**: Değişiklikler lokalize
- ✅ **Genişletilebilirlik**: Yeni özellikler kolayca eklenir
- ✅ **Teknoloji bağımsızlığı**: DB/UI değiştirilebilir

### Neden Go + Flutter?

- **Go**: Concurrent, hızlı, cross-platform binary
- **Flutter**: Tek codebase → Windows/Mac/Linux

---

## 🤝 Katkıda Bulunma

Projeye katkıda bulunmak isterseniz:

1. **Fork** edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. **Commit** edin (`git commit -m 'feat: Add amazing feature'`)
4. **Push** edin (`git push origin feature/amazing-feature`)
5. **Pull Request** açın

### Commit Mesajı Formatı

```
feat: Yeni özellik ekle
fix: Bug düzelt
docs: Dokümantasyon güncelle
refactor: Kod refactor
test: Test ekle
chore: Build/config değişiklikleri
```

---

## 📄 Lisans

Bu proje **MIT Lisansı** altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## 🙏 Teşekkürler

- [mDNS/Bonjour](https://github.com/hashicorp/mdns) - Zero-config networking
- [gRPC](https://grpc.io/) - High-performance RPC
- [Flutter](https://flutter.dev/) - Beautiful UI framework
- [BoltDB](https://github.com/etcd-io/bbolt) - Embedded key-value store

---

## 📞 İletişim

- **GitHub Issues**: Bug reports & feature requests
- **Discussions**: Genel sorular ve tartışma

---

<div align="center">

**🌐 Aether - Decentralized File Sync**

Geliştirici: SOLID prensiplerine uygun, profesyonel mimari  
Durum: 🟢 **Aktif Geliştirme**  
Versiyon: **v0.1.0** (LAN P2P Ready)

⭐ **Star** vererek projeyi destekleyin!

</div>
