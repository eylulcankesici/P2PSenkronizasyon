# 🐛 Hata Çözümleri

## ❌ Sorun: Dosya uzantısı kayboluyor / Dosya açılmıyor

### Belirtiler:
- Gönderilen `.jpg`, `.png`, `.pdf` gibi dosyaların uzantısı kaybolmuş
- Dosya adı `file_XXXXXXXX` şeklinde generic olarak kaydediliyor
- Dosyayı çift tıklayınca "Dosya türü: Dosya" olarak görünüyor ve açılmıyor

### Neden:
Proto dosyaları (`p2p.pb.go` gibi) Git'te saklanmıyor, yerelde compile edilmesi gerekiyor. Eski proto dosyası kullanılıyorsa `fileName` bilgisi gelmez.

### Çözüm:

#### 1️⃣ Backend'i Durdur
```powershell
# Backend çalışıyorsa Ctrl+C ile durdur
```

#### 2️⃣ Proto Dosyalarını Yeniden Compile Et
```powershell
protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto
```

**Başarılı çıktı:**
```
(hiçbir hata mesajı yok)
```

**Hata varsa:**
```
protoc: komut bulunamadı
```

Bu durumda protoc kurulmalı:
```powershell
# Go protoc plugins'leri kur
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

#### 3️⃣ Backend'i Yeniden Başlat
```powershell
go run cmd/aether-server/main.go
```

#### 4️⃣ Dosya Transferini Tekrar Dene

### Kontrol:

Terminal loglarında şunları görmelisin:

**Gönderen taraf:**
```
🔧 Encode: FileId='319e3c21-...', FileName='resim.jpg', ChunkIndex=0, TotalChunks=2
```

**Alıcı taraf:**
```
📥 Chunk response alındı: d74d9fc7 (262144 bytes), FileId: '319e3c21-...', FileName: 'resim.jpg', ChunkIndex: 0, TotalChunks: 2
🔍 fileName kontrol ediliyor: fileName='resim.jpg', file.RelativePath=''
✅ Gelen fileName kullanılıyor: resim.jpg
```

Eğer `FileName: ''` (boş) görüyorsan, proto dosyası hâlâ güncellenmemiş demektir.

---

## ❌ Sorun: `FileId boş, push-based sync aktif değil`

### Neden:
Proto dosyası eski, `FileId`, `ChunkIndex`, `TotalChunks` alanları yok.

### Çözüm:
Aynı yukarıdaki gibi proto dosyalarını yeniden compile et.

---

## ❌ Sorun: Git pull sonrası compile hatası

### Neden:
Proto dosyaları Git'e commit edilmiyor, yerelde oluşturulmalı.

### Çözüm:
Her `git pull` sonrası proto dosyalarını yeniden compile et:

```powershell
protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto
```

---

## 📝 Not:

Proto dosyalarının Git'te saklanmamasının nedeni:
- Farklı platformlarda (Windows/macOS/Linux) farklı şekilde compile olabilir
- Farklı protoc versiyonları uyumsuzluk yaratabilir
- Her geliştirici kendi ortamında compile ederse sorun çıkmaz

**Bu yüzden her pull sonrası proto compile etmeyi unutma!** 🚨

