# 🚀 Aether - Detaylı Kurulum Rehberi (Windows)

## 📋 **KURULUM ÖZETİ**

Bu rehber Aether P2P senkronizasyon uygulamasını Windows'ta kurmak için gereken tüm adımları içerir.

### **📦 MANUEL İNDİRİLECEK YAZILIMLAR:**
1. **Go Programming Language** - Ana programlama dili
2. **Protocol Buffers (protoc)** - Proto dosyalarını compile etmek için
3. **Flutter SDK** - UI geliştirme için

### **📦 OTOMATİK İNDİRİLEN PAKETLER:**
1. **Go Plugins** - `go install` komutu ile
2. **Proje Bağımlılıkları** - `go mod download` ile
3. **Flutter Paketleri** - `flutter pub get` ile

---

## 🔧 **ZORUNLU YAZILIMLAR (MANUEL İNDİRME)**

### **1️⃣ Go Programming Language**

#### **📥 İndirme:**
- **Kaynak:** [Go İndirme Sayfası](https://go.dev/dl/)
- **Dosya:** `go1.21.5.windows-amd64.msi` (en son sürüm)
- **Boyut:** ~140 MB

#### **🔧 Kurulum:**
1. İndirilen `.msi` dosyasını çift tıklayın
2. Kurulum sihirbazını takip edin
3. **Varsayılan ayarlar** yeterli (C:\Program Files\Go\)
4. Kurulum tamamlandığında **"Close"** butonuna tıklayın

#### **✅ Doğrulama:**
```powershell
# PowerShell veya CMD açın ve şu komutu çalıştırın:
go version

# Başarılı çıktı:
go version go1.21.5 windows/amd64
```

#### **🔧 PATH Kontrolü:**
```powershell
# Go'nun PATH'te olduğunu kontrol edin:
go env GOPATH

# Çıktı: C:\Users\[KullanıcıAdı]\go
```

---

### **2️⃣ Protocol Buffers (protoc)**

#### **📥 İndirme:**
- **Kaynak:** [Protobuf Releases](https://github.com/protocolbuffers/protobuf/releases)
- **Dosya:** `protoc-<version>-win64.zip` (en son sürüm)
- **Boyut:** ~2 MB

#### **🔧 Kurulum:**
1. ZIP dosyasını indirin
2. ZIP'i açın
3. `bin/protoc.exe` dosyasını kopyalayın
4. `C:\protoc\bin\` klasörü oluşturun ve dosyayı buraya yapıştırın

#### **📁 Klasör Yapısı:**
```
C:\protoc\
└── bin\
    └── protoc.exe
```

#### **🔧 PATH'e Ekleme:**
1. **Windows + R** tuşlarına basın
2. `sysdm.cpl` yazın ve Enter'a basın
3. **"Gelişmiş"** sekmesine tıklayın
4. **"Ortam Değişkenleri"** butonuna tıklayın
5. **"Path"** değişkenini seçin ve **"Düzenle"**'ye tıklayın
6. **"Yeni"** butonuna tıklayın
7. `C:\protoc\bin` yazın ve **"Tamam"**'a tıklayın

#### **✅ Doğrulama:**
```powershell
# PowerShell'i kapatıp yeniden açın, sonra:
protoc --version

# Başarılı çıktı:
libprotoc 3.21.12 (veya benzer)
```

---

### **3️⃣ Flutter SDK**

#### **📥 İndirme:**
- **Kaynak:** [Flutter İndirme](https://docs.flutter.dev/get-started/install/windows)
- **Dosya:** Flutter SDK ZIP dosyası
- **Boyut:** ~1.5 GB

#### **🔧 Kurulum:**
1. ZIP dosyasını indirin
2. ZIP'i açın
3. `flutter` klasörünü `C:\flutter` konumuna kopyalayın

#### **📁 Klasör Yapısı:**
```
C:\flutter\
├── bin\
│   ├── flutter.exe
│   ├── dart.exe
│   └── (diğer dosyalar)
├── packages\
├── (diğer klasörler)
```

#### **🔧 PATH'e Ekleme:**
1. **Windows + R** tuşlarına basın
2. `sysdm.cpl` yazın ve Enter'a basın
3. **"Gelişmiş"** sekmesine tıklayın
4. **"Ortam Değişkenleri"** butonuna tıklayın
5. **"Path"** değişkenini seçin ve **"Düzenle"**'ye tıklayın
6. **"Yeni"** butonuna tıklayın
7. `C:\flutter\bin` yazın ve **"Tamam"**'a tıklayın

#### **✅ Doğrulama:**
```powershell
# PowerShell'i kapatıp yeniden açın, sonra:
flutter --version

# Başarılı çıktı:
Flutter 3.16.0 • channel stable • https://github.com/flutter/flutter.git
```

---

## 📦 **OTOMATİK İNDİRİLEN PAKETLER**

### **🔧 Go Plugins (Otomatik İndirme):**
```powershell
# Go kurulduktan sonra bu komutları çalıştırın:
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Kurulumu doğrulayın:
protoc-gen-go --version
protoc-gen-go-grpc --version
```

### **🔧 Air (Hot Reload) - Opsiyonel:**
```powershell
go install github.com/cosmtrek/air@latest
```

---

## 🚀 **AETHER PROJESİNİ ÇALIŞTIRMA**

### **1️⃣ Proje Dizinine Git:**
```powershell
# Proje dizinine git (örnek):
cd C:\Aether

# Veya masaüstünde ise:
cd C:\Users\[KullanıcıAdı]\Desktop\Aether
```

### **2️⃣ Proje Bağımlılıklarını İndir:**
```powershell
# Go paketleri otomatik indirilir:
go mod download

# Başarılı çıktı: (hata yoksa başarılı)
```

### **3️⃣ Proto Dosyalarını Compile Et:**
```powershell
# Tüm proto dosyalarını compile edin:
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/common.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/folder.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/file.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/sync.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/peer.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/auth.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/p2p.proto

# Başarılı çıktı: (hata yoksa başarılı)
```

### **4️⃣ Veritabanı Dizini Oluştur:**
```powershell
# Data dizinini oluştur:
New-Item -ItemType Directory -Path "data" -Force

# Dizin oluşturuldu mu kontrol et:
Test-Path "data"
```

### **5️⃣ Backend'i Çalıştır:**
```powershell
# Backend'i çalıştır (veritabanları otomatik oluşur):
go run cmd/aether-server/main.go

# Başarılı çıktı:
# ✓ SQLite bağlantısı açıldı: C:\Aether\data\aether.db
# ✓ BoltDB bağlantısı açıldı: C:\Aether\data\aether_config.db
# ✓ Migration'lar başarıyla çalıştırıldı
# ✓ Container başarıyla oluşturuldu
# ✓ gRPC sunucusu localhost:50051 üzerinde dinleniyor
```

---

## 📱 **FLUTTER UI KURULUMU**

### **1️⃣ Flutter Bağımlılıklarını İndir:**
```powershell
# Flutter UI dizinine git:
cd flutter_ui

# Flutter paketleri otomatik indirilir:
flutter pub get

# Başarılı çıktı:
# Running "flutter pub get" in flutter_ui...
# Resolving dependencies...
# Got dependencies!
```

### **2️⃣ Flutter UI'ı Çalıştır:**
```powershell
# Flutter UI'ı çalıştır:
flutter run -d windows

# Başarılı çıktı:
# ✓ gRPC client bağlandı: localhost:50051
```

---

## ⚡ **HIZLI BAŞLANGIÇ (ÖZET)**

### **🎯 Sadece Go Backend Test Etmek İçin:**
```powershell
# 1. Go'yu kur (yukarıdaki manuel adımları takip et)
# 2. Projeye git
cd C:\Aether
# 3. Bağımlılıkları indir (otomatik)
go mod download
# 4. Proto compile et
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/common.proto
# 5. Data dizini oluştur
New-Item -ItemType Directory -Path "data" -Force
# 6. Backend'i çalıştır
go run cmd/aether-server/main.go
```

---

## 📊 **İNDİRME ÖZETİ**

### **🔧 Manuel İndirme Gerekenler:**
1. **Go Programming Language** - `go1.21.5.windows-amd64.msi` (~140 MB)
2. **Protocol Buffers** - `protoc-<version>-win64.zip` (~2 MB)
3. **Flutter SDK** - Flutter SDK ZIP dosyası (~1.5 GB)

### **📦 Otomatik İndirilen Paketler:**
1. **Go Plugins** - `protoc-gen-go`, `protoc-gen-go-grpc`
2. **Air (Opsiyonel)** - `github.com/cosmtrek/air`
3. **Proje Bağımlılıkları** - `go mod download` ile tüm Go paketleri
4. **Flutter Paketleri** - `flutter pub get` ile tüm Flutter paketleri

---

## 📁 **OLUŞTURULACAK KLASÖRLER VE KONUMLARI**

### **🔧 Zorunlu Klasörler:**
```
C:\protoc\                    ← Protocol Buffers kurulumu için
└── bin\
    └── protoc.exe

C:\flutter\                   ← Flutter SDK kurulumu için
├── bin\
│   ├── flutter.exe
│   ├── dart.exe
│   └── (diğer dosyalar)
└── (diğer klasörler)

C:\Aether\                    ← Proje dizini
└── data\                     ← Veritabanları için (otomatik oluşur)
    ├── aether.db            ← SQLite veritabanı
    └── aether_config.db     ← BoltDB veritabanı
```

### **🔧 Otomatik Oluşturulan Klasörler:**
```
C:\Aether\data\               ← Backend çalıştırıldığında otomatik oluşur
├── aether.db                ← SQLite veritabanı
├── aether_config.db         ← BoltDB veritabanı
└── chunks\                  ← Chunk dosyaları için
```

---

## 🐛 **SORUN GİDERME**

### **❌ "go: command not found" veya "'go' is not recognized"**
```powershell
# Çözüm:
# 1. Go'nun PATH'e eklendiğinden emin olun
# 2. Terminali kapatıp yeniden açın
# 3. Bilgisayarı yeniden başlatın

# Kontrol:
go version
```

### **❌ "protoc: command not found"**
```powershell
# Çözüm:
# 1. protoc'un PATH'e eklendiğinden emin olun
# 2. Terminali kapatıp yeniden açın

# Kontrol:
protoc --version
```

### **❌ "flutter: command not found"**
```powershell
# Çözüm:
# 1. Flutter'ın PATH'e eklendiğinden emin olun
# 2. Terminali kapatıp yeniden açın

# Kontrol:
flutter --version
```

### **❌ Import hatalarını görmek**
```powershell
# Çözüm:
go mod tidy
go mod download
```

### **❌ Proto compile hatası**
```powershell
# Çözüm:
# 1. protoc-gen-go ve protoc-gen-go-grpc'nin kurulu olduğundan emin olun
# 2. GOPATH/bin klasörünün PATH'te olduğundan emin olun

# Kontrol:
go env GOPATH
protoc-gen-go --version
protoc-gen-go-grpc --version
```

### **❌ Veritabanı bağlantı hatası**
```powershell
# Çözüm:
# 1. Data dizinini oluşturun
New-Item -ItemType Directory -Path "data" -Force

# 2. Backend'i yeniden çalıştırın
go run cmd/aether-server/main.go
```

### **❌ gRPC bağlantı hatası**
```powershell
# Çözüm:
# 1. Backend'in çalıştığını kontrol edin
# 2. Port 50051'in açık olduğunu kontrol edin
netstat -an | findstr :50051

# 3. Flutter UI'ı yeniden başlatın
cd flutter_ui
flutter run -d windows
```

---

## 📞 **YARDIM VE DESTEK**

### **🔍 Sorun Yaşarsanız:**
1. **Go versiyonunu kontrol edin:** `go version`
2. **protoc versiyonunu kontrol edin:** `protoc --version`
3. **Flutter versiyonunu kontrol edin:** `flutter --version`
4. **PATH değişkenlerini kontrol edin**
5. **Terminali kapatıp yeniden açın**

### **📋 Kontrol Listesi:**
- [ ] Go kurulu ve PATH'te
- [ ] protoc kurulu ve PATH'te
- [ ] Flutter kurulu ve PATH'te
- [ ] Proje bağımlılıkları indirildi
- [ ] Proto dosyaları compile edildi
- [ ] Data dizini oluşturuldu
- [ ] Backend çalışıyor
- [ ] Flutter UI çalışıyor

---

## 🎯 **BAŞARILI KURULUM DOĞRULAMA**

### **✅ Backend Başarılı Mesajları:**
```
✓ SQLite bağlantısı açıldı: C:\Aether\data\aether.db
✓ BoltDB bağlantısı açıldı: C:\Aether\data\aether_config.db
✓ Migration'lar başarıyla çalıştırıldı
✓ Container başarıyla oluşturuldu
✓ gRPC sunucusu localhost:50051 üzerinde dinleniyor
✓ P2P Transport başlatıldı
```

### **✅ Flutter UI Başarılı Mesajları:**
```
✓ gRPC client bağlandı: localhost:50051
✓ Flutter UI başarıyla başlatıldı
```

---

**🎉 Kurulum tamamlandı! Artık Aether P2P senkronizasyon uygulamasını kullanabilirsiniz.**

---

**⚠️ ÖNEMLİ NOT:** Tüm kurulumlardan sonra terminal/PowerShell'i kapatıp yeniden açmayı unutmayın!

