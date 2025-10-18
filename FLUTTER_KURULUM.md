# Flutter Kurulum Rehberi (Windows)

## 📥 Flutter SDK Kurulumu

### Adım 1: Flutter'ı İndirin

1. [Flutter Resmi Sitesi](https://docs.flutter.dev/get-started/install/windows) adresine gidin
2. **"flutter_windows_X.X.X-stable.zip"** dosyasını indirin (en son kararlı sürüm)
3. ZIP dosyasını açın ve `C:\` dizinine çıkartın (örn: `C:\flutter`)

   **ÖNEMLİ**: Program Files veya Türkçe karakter içeren klasörlere çıkartmayın!

### Adım 2: PATH'e Ekleyin

1. Windows arama çubuğunda **"ortam değişkenleri"** yazın
2. **"Sistem ortam değişkenlerini düzenle"** seçeneğini açın
3. **"Ortam Değişkenleri"** butonuna tıklayın
4. **"Kullanıcı değişkenleri"** bölümünde **"Path"** seçin
5. **"Düzenle"** butonuna tıklayın
6. **"Yeni"** butonuna tıklayıp şunu ekleyin: `C:\flutter\bin`
7. **"Tamam"** ile kaydedin

### Adım 3: Flutter Doctor Çalıştırın

**YENİ** bir PowerShell/CMD açın (eski terminalinizi kapatın!) ve şunu çalıştırın:

```powershell
flutter doctor
```

Bu komut eksik bağımlılıkları gösterecektir:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, X.X.X)
[✗] Windows Version (Unable to confirm if installed Windows version is 10 or greater)
[!] Android toolchain - develop for Android devices
[✗] Chrome - develop for the web (Cannot find Chrome executable)
[✓] Visual Studio - develop Windows apps
[!] Android Studio (not installed)
[✓] VS Code (version X.X.X)
```

### Adım 4: Windows Masaüstü Desteği

Windows masaüstü uygulaması için:

```powershell
flutter config --enable-windows-desktop
```

### Adım 5: Visual Studio Gereksinimleri

Flutter Windows uygulamaları için **Visual Studio 2022** gereklidir:

#### Seçenek A: Visual Studio Community 2022 (Ücretsiz)

1. [Visual Studio İndirme](https://visualstudio.microsoft.com/downloads/) sayfasına gidin
2. **Visual Studio Community 2022** indirin
3. Kurulum sırasında şu bileşenleri seçin:
   - ✅ **Desktop development with C++**
   - ✅ **Windows 10 SDK** (10.0.17763.0 veya üstü)

#### Seçenek B: Build Tools (Daha Hafif)

Sadece build için gerekli araçları kurmak isterseniz:

1. [Build Tools İndirme](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022)
2. **Build Tools for Visual Studio 2022** indirin
3. Kurulum sırasında:
   - ✅ **Desktop development with C++**
   - ✅ **Windows 10 SDK**

### Adım 6: Tekrar Flutter Doctor

Kurulumdan sonra tekrar kontrol edin:

```powershell
flutter doctor
```

Windows için gerekli olanlar:
```
[✓] Flutter
[✓] Windows Version
[✓] Visual Studio
[✓] VS Code (veya Android Studio)
```

## 🚀 Aether Flutter UI'ı Çalıştırma

### 1. Projeye Gidin

```powershell
cd C:\Users\eylul\OneDrive\Masaüstü\Aether\flutter_ui
```

### 2. Bağımlılıkları İndirin

```powershell
flutter pub get
```

### 3. Uygulamayı Çalıştırın

```powershell
flutter run -d windows
```

İlk çalıştırma biraz uzun sürecektir (C++ kodları derleniyor).

## 🎨 VS Code İçin (Opsiyonel)

Flutter geliştirme için VS Code önerilir:

### 1. VS Code Extension'ları

VS Code'da şu extension'ları kurun:
- **Flutter** (Dart-Code.flutter)
- **Dart** (Dart-Code.dart-code)

### 2. VS Code'dan Çalıştırma

1. `flutter_ui` klasörünü VS Code'da açın
2. `F5` tuşuna basın veya "Run" menüsünden "Start Debugging"
3. Cihaz seçin: **Windows (windows)**

## 📱 Flutter Komutları

```powershell
# Flutter versiyonu
flutter --version

# Cihazları listele
flutter devices

# Projeyi temizle
flutter clean

# Bağımlılıkları güncelle
flutter pub upgrade

# Release build
flutter build windows --release

# Hot reload (çalışırken 'r' tuşuna basın)
# Hot restart (çalışırken 'R' tuşuna basın)
```

## 🐛 Sorun Giderme

### "Unable to find git in your PATH"
```powershell
winget install --id Git.Git -e --source winget
```

### "cmdline-tools component is missing"
Android Studio kurulu değilse görmezden gelin (sadece Windows için gerekli değil).

### "Chrome executable not found"
Web geliştirme yapmayacaksanız görmezden gelin.

### Visual Studio eksik
```powershell
flutter doctor --verbose
```
Detaylı hata mesajını okuyun ve eksik SDK'ları kurun.

## ✅ Başarı Kontrolü

Flutter düzgün kurulmuşsa:

```powershell
flutter doctor
```

Çıktıda en az şunlar olmalı:
```
[✓] Flutter (Channel stable, X.X.X, on Microsoft Windows)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Visual Studio - develop Windows apps (Visual Studio Community 2022 XX.X.X)
```

Artık Flutter uygulamalarını geliştirebilirsiniz! 🎉

---

## 🎯 Sonraki Adım

```powershell
cd C:\Users\eylul\OneDrive\Masaüstü\Aether\flutter_ui
flutter pub get
flutter run -d windows
```




