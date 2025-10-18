# Aether - Geliştirme Kılavuzu

## 🚀 Hızlı Başlangıç

### Backend'i Başlatma

#### Yöntem 1: PowerShell Script (Önerilen)
```powershell
.\start-backend.ps1
```

#### Yöntem 2: Manuel (Ön Plan - Ctrl+C ile kapanır)
```powershell
cd C:\Aether
go run cmd/aether-server/main.go
```

### Backend'i Durdurma

#### Yöntem 1: PowerShell Script (Önerilen)
```powershell
.\stop-backend.ps1
```

#### Yöntem 2: Ön Planda Çalışıyorsa
- Terminal'de `Ctrl+C` tuşuna basın

#### Yöntem 3: Manuel Process Kapatma
```powershell
# Process ID'yi bul
netstat -ano | findstr :50051

# Process'i kapat (12345 yerine gerçek PID'yi yazın)
taskkill /PID 12345

# Kapanmazsa force kapat
taskkill /F /PID 12345
```

---

## 🖥️ Flutter UI'ı Çalıştırma

### Terminal 2'de
```powershell
cd C:\Aether\flutter_ui
flutter run -d windows
```

### Hot Reload (Geliştirme Sırasında)
- Kod değişikliği yaptıktan sonra terminalde `r` tuşuna basın
- Tam yeniden başlatma için `R` tuşuna basın
- Durdurmak için `q` tuşuna basın

---

## 🔧 Port Sorunları

### Port 50051 Zaten Kullanımda Hatası

**Sorun:**
```
bind: Only one usage of each socket address... normally permitted
```

**Çözüm:**
```powershell
# Otomatik çözüm
.\stop-backend.ps1

# Veya manuel
netstat -ano | findstr :50051
taskkill /F /PID <PID_NUMARASI>
```

---

## 📁 Proje Yapısı

```
C:\Aether\
├── cmd/
│   └── aether-server/
│       └── main.go              # Backend giriş noktası
├── internal/
│   ├── delivery/grpc/           # gRPC handlers
│   ├── domain/                  # Business logic
│   └── infrastructure/          # Database, external services
├── flutter_ui/
│   ├── lib/
│   │   ├── main.dart           # Flutter giriş noktası
│   │   ├── features/           # UI sayfaları
│   │   ├── data/               # Providers, services
│   │   └── generated/          # Proto generated code
│   └── pubspec.yaml
├── api/proto/                   # Protobuf definitions
├── data/                        # SQLite database (runtime)
├── start-backend.ps1           # Backend başlatma script
└── stop-backend.ps1            # Backend durdurma script
```

---

## 🗄️ Veritabanı Yönetimi

Aether iki veritabanı kullanır:
- **SQLite** (`aether.db`) - Yapısal veriler (klasörler, dosyalar, kullanıcılar)
- **BoltDB** (`aether_config.db`) - Konfigürasyon ve cache

### SQLite Veritabanı Kontrolü
```powershell
# Hızlı kontrol (PowerShell script)
.\check-db.ps1

# SQLite CLI ile
sqlite3 "C:\Users\<KULLANICI>\.aether\aether.db"

# DB Browser for SQLite ile (GUI)
# Dosyayı aç: C:\Users\<KULLANICI>\.aether\aether.db
```

### BoltDB Veritabanı Görüntüleme
```powershell
# BoltDB içeriğini görüntüle (key-value çiftleri)
go run cmd/view-boltdb/main.go
```

### Veritabanı Test Programları
```powershell
# SQLite CRUD testi
go run cmd/test-db/main.go

# Her iki veritabanını test et
go run cmd/test-both-db/main.go
```

### Manuel SQL Sorguları
```powershell
# Tüm klasörleri listele
sqlite3 "C:\Users\<KULLANICI>\.aether\aether.db" "SELECT * FROM folders;"

# Kullanıcıları listele
sqlite3 "C:\Users\<KULLANICI>\.aether\aether.db" "SELECT * FROM users;"

# Migration geçmişi
sqlite3 "C:\Users\<KULLANICI>\.aether\aether.db" "SELECT * FROM schema_migrations;"
```

### Veritabanı Lokasyonu
- **Windows**: `C:\Users\<KULLANICI>\.aether\aether.db`
- **Linux/Mac**: `~/.aether/aether.db`

---

## 🐛 Debugging

### Backend Loglarını Görmek
Backend'i ön planda çalıştırırsanız tüm loglar console'da görünür:
```
2025/10/17 20:03:48 Aether başlatılıyor...
2025/10/17 20:03:48 gRPC sunucusu localhost:50051 üzerinde dinleniyor
2025/10/17 20:03:48 ✓ Aether başarıyla başlatıldı!
```

### Flutter Loglarını Görmek
Flutter ön planda çalışırken:
- Tüm print() çıktıları terminalde görünür
- Hot reload ile hızlı test yapabilirsiniz

### gRPC Bağlantı Testi
```powershell
# Backend çalışıyor mu?
netstat -ano | findstr :50051

# gRPCurl ile test (opsiyonel)
grpcurl -plaintext localhost:50051 list
```

---

## 🔄 Prototipleri Yeniden Derleme

### Go için
```powershell
make proto
# Veya manuel:
protoc --go_out=. --go-grpc_out=. api/proto/*.proto
```

### Dart için
```powershell
protoc --dart_out=grpc:flutter_ui/lib/generated -I. api/proto/*.proto
```

---

## 📊 Database Kontrolü

SQLite database yeri:
```
C:\Users\<KULLANICI>\.aether\aether.db
```

DB Browser for SQLite ile açabilirsiniz:
```powershell
# İndirin: https://sqlitebrowser.org/
```

---

## ✅ Checklist: Geliştirmeye Başlamadan

- [ ] Go kurulu mu? (`go version`)
- [ ] Flutter kurulu mu? (`flutter doctor`)
- [ ] Protoc kurulu mu? (`protoc --version`)
- [ ] Port 50051 boş mu? (`netstat -ano | findstr :50051`)
- [ ] Backend çalışıyor mu?
- [ ] Flutter UI çalışıyor mu?

---

## 🆘 Sorun Giderme

### Backend başlamıyor
1. `go mod download` çalıştırın
2. Port 50051'i kontrol edin
3. `data/aether.db` oluşabilir mi kontrol edin

### Flutter build hatası
1. `flutter clean` çalıştırın
2. `flutter pub get` çalıştırın
3. `flutter create --platforms=windows .` çalıştırın (gerekirse)

### gRPC bağlantı hatası
1. Backend'in çalıştığından emin olun
2. `localhost:50051` erişilebilir mi kontrol edin
3. Firewall ayarlarını kontrol edin

