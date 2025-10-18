# 🚀 GitHub Push Rehberi

Bu dosya projeyi GitHub'a push'lamak için gereken tüm adımları içerir.

## ✅ Tamamlanan Hazırlıklar

- ✅ `.gitignore` oluşturuldu (Go, Flutter, IDE, binaries)
- ✅ `README.md` güncellendi (detaylı dokümantasyon)
- ✅ `LICENSE` eklendi (MIT License)
- ✅ Gereksiz dosyalar temizlendi (exe, temp files)

---

## 📋 GitHub'a Push Adımları

### 1️⃣ Git Repository Oluştur (İlk Kez)

```bash
# Git repository'yi başlat
git init

# Kullanıcı bilgilerini ayarla (ilk kez yapılıyorsa)
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### 2️⃣ Dosyaları Staging'e Ekle

```bash
# Tüm dosyaları ekle (.gitignore'a uygun olarak)
git add .

# Eklenen dosyaları kontrol et
git status
```

**Kontrol edilmesi gerekenler:**
- ✅ `*.go` dosyaları eklenmeli
- ✅ `*.proto` dosyaları eklenmeli
- ✅ `*.dart` dosyaları eklenmeli
- ✅ `go.mod`, `go.sum` eklenmeli
- ✅ `pubspec.yaml` eklenmeli
- ❌ `*.exe`, `*.db`, `build/` eklenmemeli (.gitignore tarafından ignore edilir)

### 3️⃣ İlk Commit

```bash
# İlk commit'i oluştur
git commit -m "feat: Initial commit - P2P file sync with LAN support

Features:
- Clean Architecture (Go + Flutter)
- SQLite & BoltDB integration
- Chunking system (256KB, SHA-256)
- Content-addressable storage
- File reassembly
- P2P LAN networking (mDNS + TCP)
- gRPC API (all services)
- Flutter desktop UI (folder/file management)

Status: v0.1.0 - LAN P2P Ready"
```

### 4️⃣ GitHub'da Repository Oluştur

1. GitHub'a git: https://github.com
2. "New repository" butonuna tıkla
3. Repository adı: `aether` (veya istediğiniz)
4. Description: "Self-hosted P2P file synchronization tool"
5. **Public** veya **Private** seç
6. ⚠️ **README, .gitignore, LICENSE ekleme** (bizde zaten var)
7. "Create repository" tıkla

### 5️⃣ Remote Repository Bağla

GitHub'dan verilen komutları kullan:

```bash
# Remote repository ekle (SSH)
git remote add origin git@github.com:yourusername/aether.git

# Veya HTTPS ile
git remote add origin https://github.com/yourusername/aether.git

# Remote'u kontrol et
git remote -v
```

### 6️⃣ Push Et!

```bash
# Main branch'i push et
git push -u origin main

# Eğer "master" branch kullanıyorsan
git push -u origin master
```

---

## 🔄 Gelecekteki Push'lar

Kod değişikliklerinden sonra:

```bash
# Değişiklikleri ekle
git add .

# Commit oluştur
git commit -m "feat: Add new feature"

# Push et
git push
```

---

## 📝 Commit Mesajı Kuralları

### Format
```
<type>: <subject>

<body> (optional)

<footer> (optional)
```

### Types
- `feat`: Yeni özellik
- `fix`: Bug düzeltme
- `docs`: Dokümantasyon
- `refactor`: Kod iyileştirme
- `test`: Test ekleme/güncelleme
- `chore`: Build, config değişiklikleri
- `perf`: Performance iyileştirme

### Örnekler

```bash
git commit -m "feat: Add WAN support with STUN/TURN"
git commit -m "fix: Resolve chunk reassembly bug"
git commit -m "docs: Update README with new features"
git commit -m "refactor: Improve P2P connection pooling"
git commit -m "test: Add E2E transfer tests"
```

---

## 🌿 Branch Strategy (İlerisi İçin)

### Main Branches
- `main` / `master`: Stable production code
- `develop`: Development branch

### Feature Branches
```bash
# Yeni feature için branch oluştur
git checkout -b feature/wan-support

# Çalış, commit yap
git commit -m "feat: Add STUN client"

# Push et
git push -u origin feature/wan-support

# GitHub'da Pull Request aç
```

---

## ⚠️ Önemli Notlar

### Push Etmeden Önce Kontrol Et:

```bash
# Hangi dosyalar commit edilecek?
git status

# Hangi değişiklikler var?
git diff

# Commit geçmişi
git log --oneline
```

### .gitignore Kontrol

Aşağıdaki dosyalar GitHub'a GİTMEMELİ:
- ❌ `.aether/` (user data)
- ❌ `*.db`, `*.db-shm`, `*.db-wal` (local databases)
- ❌ `*.exe`, `*.dll` (binaries)
- ❌ `build/`, `bin/` (build artifacts)
- ❌ `.dart_tool/`, `.pub-cache/` (Flutter cache)
- ❌ `node_modules/` (if any)
- ❌ `.env` (if exists)

### GitHub'da Görecekleriniz:

```
aether/
├── .gitignore
├── LICENSE
├── README.md
├── P2P_ARCHITECTURE.md
├── go.mod
├── go.sum
├── Makefile
├── cmd/
├── internal/
├── pkg/
├── api/proto/
├── flutter_ui/
└── ...
```

---

## 🆘 Sorun Giderme

### "Permission denied (publickey)" Hatası

**SSH key oluştur:**
```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**Public key'i GitHub'a ekle:**
1. `cat ~/.ssh/id_ed25519.pub` ile key'i kopyala
2. GitHub → Settings → SSH and GPG keys → New SSH key

### "Failed to push" Hatası

```bash
# Remote'u kontrol et
git remote -v

# Pull yap (eğer GitHub'da dosya varsa)
git pull origin main --rebase

# Tekrar push et
git push
```

### "Large files" Uyarısı

```bash
# Eğer yanlışlıkla büyük dosya eklendiyse
git rm --cached <file>
git commit -m "chore: Remove large file"
```

---

## 🎉 Başarı!

Push başarılı olduktan sonra:

1. ⭐ Repository'ye **star** ekle
2. 📝 Repository description güncelle
3. 🏷️ Topics ekle: `go`, `flutter`, `p2p`, `file-sync`, `self-hosted`
4. 📖 GitHub Pages ile dokümantasyon (optional)
5. 🤝 Arkadaşını davet et (collaborator)

---

## 📞 İletişim

Sorularınız için:
- GitHub Issues
- GitHub Discussions

---

**🚀 Kolay gelsin!**

