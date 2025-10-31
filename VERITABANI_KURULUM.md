# 🗄️ Aether Veritabanı Kurulum Rehberi

## 🎯 **SORUN: VERİTABANLARI YOK**

Arkadaşlarınızda backend ve arayüz çalışıyor ancak veritabanları oluşturulmamış. Bu rehber ile veritabanlarını kuracaksınız.

---

## 🔧 **ADIM ADIM KURULUM**

### **1️⃣ PROJE DİZİNİNE GİT**
```powershell
# Aether projesinin bulunduğu dizine git
cd C:\Aether
# veya
cd C:\Users\[KullanıcıAdı]\Desktop\Aether
```

### **2️⃣ BAĞIMLILIKLARI İNDİR**
```powershell
# Go bağımlılıklarını indir
go mod download

# Eksik paketleri temizle ve yeniden indir
go mod tidy
```

### **3️⃣ PROTO DOSYALARINI COMPILE ET**
```powershell
# Tüm proto dosyalarını compile et (include path ile):
protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto
```

### **4️⃣ DATA DİZİNİNİ OLUŞTUR**
```powershell
# Data dizinini oluştur
New-Item -ItemType Directory -Path "data" -Force

# Dizin oluşturuldu mu kontrol et
Test-Path "data"
```

### **5️⃣ UYGULAMAYI İLK KEZ ÇALIŞTIR**
```powershell
# Backend'i çalıştır (veritabanları otomatik oluşturulacak)
go run cmd/aether-server/main.go
```

**ÖNEMLİ:** Uygulamayı çalıştırdığınızda şu mesajları görmelisiniz:
```
✓ SQLite bağlantısı açıldı: C:\Aether\data\aether.db
✓ BoltDB bağlantısı açıldı: C:\Aether\data\aether_config.db
✓ Migration'lar başarıyla çalıştırıldı
✓ Container başarıyla oluşturuldu
```

---

## 🔍 **VERİTABANI KURULUM KONTROLÜ**

### **✅ OLUŞMASI GEREKEN DOSYALAR:**
```
C:\Aether\data\
├── aether.db          ← SQLite veritabanı
├── aether_config.db   ← BoltDB veritabanı
└── (diğer cache dosyaları)
```

### **🔍 KONTROL KOMUTLARI:**
```powershell
# Data dizinini kontrol et
dir C:\Aether\data

# SQLite dosyası var mı?
Test-Path "C:\Aether\data\aether.db"

# BoltDB dosyası var mı?
Test-Path "C:\Aether\data\aether_config.db"
```

---

## 🚨 **SORUN GİDERME**

### **❌ HATA 1: "data dizini oluşturulamadı"**
```powershell
# Manuel olarak data dizinini oluştur
New-Item -ItemType Directory -Path "data" -Force

# İzinleri kontrol et
icacls "data" /grant Everyone:F
```

### **❌ HATA 2: "veritabanı bağlantısı açılamadı"**
```powershell
# SQLite ve BoltDB bağımlılıklarını kontrol et
go mod tidy
go mod download

# Uygulamayı yeniden çalıştır
go run cmd/aether-server/main.go
```

### **❌ HATA 3: "migration'lar çalıştırılamadı"**
```powershell
# Go mod'u temizle ve yeniden indir
go clean -modcache
go mod download

# Uygulamayı yeniden çalıştır
go run cmd/aether-server/main.go
```

### **❌ HATA 4: "protoc: command not found"**
```powershell
# protoc'un PATH'te olduğunu kontrol et
where protoc

# PATH'e ekle (geçici)
$env:PATH += ";C:\protoc\bin"

# Kalıcı olarak eklemek için:
# 1. Windows aramasında "Ortam Değişkenleri" yaz
# 2. "Sistem ortam değişkenlerini düzenle"yi aç
# 3. "Ortam Değişkenleri" butonuna tıkla
# 4. "Path" değişkenini seçip "Düzenle"ye tıkla
# 5. "Yeni" butonuna tıklayıp C:\protoc\bin ekle
```

---

## 🎯 **HIZLI KURULUM SCRIPT'İ**

### **📝 KURULUM SCRIPT'İ OLUŞTUR:**
```powershell
# setup-database.ps1 dosyası oluştur
@"
Write-Host "Aether veritabanı kurulumu başlatılıyor..."

# 1. Bağımlılıkları indir
Write-Host "Bağımlılıklar indiriliyor..."
go mod download

# 2. Proto compile
Write-Host "Proto dosyaları compile ediliyor..."
Get-ChildItem -Path "api/proto" -Filter "*.proto" | ForEach-Object {
    Write-Host "Compiling $($_.Name)..."
    protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative "api/proto/$($_.Name)"
}

# 3. Data dizini oluştur
Write-Host "Data dizini oluşturuluyor..."
New-Item -ItemType Directory -Path "data" -Force

# 4. Uygulamayı çalıştır
Write-Host "Uygulama başlatılıyor..."
Write-Host "Veritabanları otomatik oluşturulacak..."
go run cmd/aether-server/main.go
"@ | Out-File -FilePath "setup-database.ps1" -Encoding UTF8

# Script'i çalıştır
.\setup-database.ps1
```

---

## 🎉 **KURULUM SONRASI TEST**

### **✅ KLASÖR EKLEME TESTİ:**
```
1. Flutter UI'da "Klasör Ekle" butonuna tıkla
2. Bir klasör seç
3. "Klasörler" sekmesine git
4. Eklenen klasör görünmeli
```

### **🔍 VERİTABANI İÇERİĞİ KONTROLÜ:**
```powershell
# SQLite veritabanını kontrol et (opsiyonel)
sqlite3 C:\Aether\data\aether.db "SELECT * FROM folders;"
```

---

## 📊 **BEKLENEN LOG MESAJLARI**

### **✅ BAŞARILI KURULUM:**
```
✓ SQLite bağlantısı açıldı: C:\Aether\data\aether.db
✓ BoltDB bağlantısı açıldı: C:\Aether\data\aether_config.db
✓ Migration'lar başarıyla çalıştırıldı
✓ Container başarıyla oluşturuldu
✓ P2P Transport başlatıldı
✓ Yeni device ID oluşturuldu: [device-id]
```

### **❌ HATA MESAJLARI:**
```
❌ veritabanı bağlantısı açılamadı
❌ migration'lar çalıştırılamadı
❌ protoc: command not found
❌ data dizini oluşturulamadı
```

---

## 🚀 **HIZLI KURULUM (TEK KOMUT)**

### **⚡ TÜM ADIMLARI TEK SEFERDE:**
```powershell
# Tüm kurulum adımlarını tek seferde çalıştır
go mod download; protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto; New-Item -ItemType Directory -Path "data" -Force; go run cmd/aether-server/main.go
```

---

## 🎯 **ÖZET**

### **🔧 YAPILACAKLAR:**
1. **Proje dizinine git**
2. **Bağımlılıkları indir** (`go mod download`)
3. **Proto dosyalarını compile et** (1 komut)
4. **Data dizinini oluştur** (`New-Item -ItemType Directory -Path "data" -Force`)
5. **Uygulamayı çalıştır** (`go run cmd/aether-server/main.go`)

### **✅ SONUÇ:**
- **SQLite veritabanı** oluşturulur
- **BoltDB veritabanı** oluşturulur
- **Tablo yapıları** oluşturulur
- **Klasör ekleme** çalışır

**Veritabanı kurulumu tamamlandıktan sonra klasör ekleme işlemi düzgün çalışacak!** 🗄️✨

---

## 📞 **YARDIM**

Sorun yaşarsanız:
1. **Go versiyonunu kontrol edin**: `go version`
2. **Go environment'ı kontrol edin**: `go env`
3. **PATH değişkenlerini kontrol edin**
4. **protoc kurulu mu kontrol edin**: `protoc --version`

**Not**: Tüm kurulumlardan sonra terminal/PowerShell'i kapatıp yeniden açmayı unutmayın!
