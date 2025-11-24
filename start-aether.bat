@echo off
REM Aether - Backend + Frontend Başlatma Script'i
REM Bu script hem Go backend'i hem de Flutter frontend'i aynı anda başlatır

echo ================================================
echo         AETHER - SYNC PLATFORMU
echo ================================================
echo.
echo Backend ve Frontend başlatılıyor...
echo.

REM Backend'i derle
echo [1/3] Backend derleniyor...
go build -o aether-server.exe ./cmd/aether-server
if %errorlevel% neq 0 (
    echo.
    echo ❌ Backend derlenemedi!
    pause
    exit /b 1
)
echo ✅ Backend derlendi
echo.

REM Backend'i arka planda başlat (yeni terminal penceresi)
echo [2/3] Backend başlatılıyor...
start "Aether Backend" cmd /k "aether-server.exe"
echo ✅ Backend başlatıldı (ayrı pencerede)
echo.

REM Flutter bağımlılıklarını kontrol et
echo [3/3] Frontend başlatılıyor...
cd flutter_ui
flutter pub get >nul 2>&1
echo ✅ Flutter bağımlılıkları güncellendi
echo.

REM Flutter'ı başlat (yeni terminal penceresi)
echo 🚀 Flutter UI başlatılıyor...
start "Aether Frontend" cmd /k "flutter run -d windows"
echo ✅ Frontend başlatıldı (ayrı pencerede)
echo.

cd ..

echo ================================================
echo            BAŞLATMA TAMAMLANDI!
echo ================================================
echo.
echo 📡 Backend: http://localhost:50051 (gRPC)
echo 🎨 Frontend: Windows Desktop App
echo.
echo Her iki uygulama da ayrı terminal pencerelerinde çalışıyor.
echo Durdurmak için her iki pencereyi de kapatın veya Ctrl+C yapın.
echo.
pause

