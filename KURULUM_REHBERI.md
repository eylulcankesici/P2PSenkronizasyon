# Aether - Kurulum Rehberi (Windows)

## 🔧 Gerekli Yazılımlar

### 1. Go Kurulumu

#### Adım 1: Go'yu İndirin
1. [Go İndirme Sayfası](https://go.dev/dl/) adresine gidin
2. **Windows** için en son sürümü indirin (örn: `go1.21.5.windows-amd64.msi`)
3. İndirilen `.msi` dosyasını çalıştırın
4. Kurulum sihirbazını takip edin (varsayılan ayarlar yeterli)

#### Adım 2: Kurulumu Doğrulayın
PowerShell veya CMD'de şu komutu çalıştırın:
```powershell
go version
```

Başarılı ise şöyle bir çıktı göreceksiniz:
```
go version go1.21.5 windows/amd64
```

#### Adım 3: GOPATH'i Kontrol Edin
```powershell
go env GOPATH
```

### 2. Protocol Buffers (protoc) Kurulumu

#### Adım 1: protoc'u İndirin
1. [Protobuf Releases](https://github.com/protocolbuffers/protobuf/releases) sayfasına gidin
2. En son sürümden `protoc-<version>-win64.zip` dosyasını indirin
3. ZIP'i açın ve `bin/protoc.exe` dosyasını bir yere kopyalayın (örn: `C:\protoc\bin\`)

#### Adım 2: PATH'e Ekleyin
1. Windows aramasında "Ortam Değişkenleri" yazın
2. "Sistem ortam değişkenlerini düzenle"yi açın
3. "Ortam Değişkenleri" butonuna tıklayın
4. "Path" değişkenini seçip "Düzenle"ye tıklayın
5. "Yeni" butonuna tıklayıp protoc'un bulunduğu klasörü ekleyin (örn: `C:\protoc\bin`)

#### Adım 3: Kurulumu Doğrulayın
```powershell
protoc --version
```

### 3. Go Plugins Kurulumu

Go kurulduktan sonra bu plugin'leri kurun:

```powershell
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

Kurulumu doğrulayın:
```powershell
protoc-gen-go --version
protoc-gen-go-grpc --version
```

### 4. Air (Hot Reload) Kurulumu (Opsiyonel)

```powershell
go install github.com/cosmtrek/air@latest
```

## 🚀 Aether Projesini Çalıştırma

### Adım 1: Bağımlılıkları İndirin

```powershell
cd C:\Users\eylul\OneDrive\Masaüstü\Aether
go mod download
```

### Adım 2: Proto Dosyalarını Compile Edin

**Windows için PowerShell:**
```powershell
# Proto dosyalarını tek tek compile edin
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/common.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/folder.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/file.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/sync.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/peer.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/auth.proto
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/p2p.proto
```

### Adım 3: Uygulamayı Çalıştırın

```powershell
go run cmd/aether-server/main.go
```

## 📱 Flutter UI Kurulumu

### 1. Flutter SDK Kurulumu

#### Adım 1: Flutter'ı İndirin
1. [Flutter İndirme](https://docs.flutter.dev/get-started/install/windows) sayfasına gidin
2. Flutter SDK'yı indirin
3. Bir klasöre çıkartın (örn: `C:\flutter`)
4. PATH'e ekleyin: `C:\flutter\bin`

#### Adım 2: Flutter Doctor
```powershell
flutter doctor
```

Bu komut eksik bağımlılıkları gösterecektir.

### 2. Flutter Projesini Çalıştırın

```powershell
cd flutter_ui
flutter pub get
flutter run -d windows
```

## ⚡ Hızlı Başlangıç (Özet)

Sadece Go backend'i test etmek için:

```powershell
# 1. Go'yu kur (yukarıdaki adımları takip et)

# 2. Projeye git
cd C:\Users\eylul\OneDrive\Masaüstü\Aether

# 3. Bağımlılıkları indir
go mod download

# 4. Çalıştır
go run cmd/aether-server/main.go
```

## 🐛 Sorun Giderme

### "go: command not found" veya "'go' is not recognized"
- Go'nun PATH'e eklendiğinden emin olun
- Terminali kapatıp yeniden açın
- Bilgisayarı yeniden başlatın

### "protoc: command not found"
- protoc'un PATH'e eklendiğinden emin olun
- Terminali kapatıp yeniden açın

### Import hatalarını görmek
- `go mod tidy` komutunu çalıştırın
- Eksik paketleri tekrar indirin: `go mod download`

### Proto compile hatası
- protoc-gen-go ve protoc-gen-go-grpc'nin kurulu olduğundan emin olun
- `go env GOPATH` çıktısındaki `bin` klasörünün PATH'te olduğundan emin olun

## 📞 Yardım

Sorun yaşarsanız:
1. Go versiyonunu kontrol edin: `go version`
2. Go environment'ı kontrol edin: `go env`
3. PATH değişkenlerini kontrol edin

---

**Not**: Tüm kurulumlardan sonra terminal/PowerShell'i kapatıp yeniden açmayı unutmayın!





