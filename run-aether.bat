@echo off
REM Aether Server Launcher
REM Data dizinini OneDrive dışında tutar

set AETHER_DATA_DIR=C:\AetherData
echo Aether başlatılıyor...
echo Data dizini: %AETHER_DATA_DIR%
echo.

go run cmd/aether-server/main.go

pause



