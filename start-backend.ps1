# Aether Backend Başlatma Script'i

Write-Host "Aether Backend Baslatiliyor..." -ForegroundColor Green

# Port kontrolü
$portInUse = Get-NetTCPConnection -LocalPort 50051 -ErrorAction SilentlyContinue

# ==========================================
# AYARLAR
# ==========================================
# Buraya ngrok adresinizi yazın (wss://.../ws formatında)
$SignalingUrl = wss://hyperrationally-artistic-elane.ngrok-free.dev/ws  

# Eğer environment variable zaten ayarlı değilse, buradaki değeri kullan
if (-not $env:SIGNALING_URL) {
    $env:SIGNALING_URL = $SignalingUrl
}

$env:AETHER_ENABLE_WAN = "1"
if ($portInUse) {
    Write-Host "UYARI: Port 50051 zaten kullanımda!" -ForegroundColor Yellow
    Write-Host "Process ID: $($portInUse.OwningProcess)" -ForegroundColor Yellow
    
    $response = Read-Host "Mevcut process'i kapatıp devam edilsin mi? (E/H)"
    
    if ($response -eq "E" -or $response -eq "e") {
        Write-Host "Process kapatiliyor..." -ForegroundColor Yellow
        Stop-Process -Id $portInUse.OwningProcess -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    } else {
        Write-Host "Iptal edildi." -ForegroundColor Red
        exit
    }
}

# Backend'i başlat
Write-Host "Backend baslatiliyor..." -ForegroundColor Green
go run cmd/aether-server/main.go



