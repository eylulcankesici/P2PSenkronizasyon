# Aether Backend Başlatma Script'i

Write-Host "Aether Backend Başlatılıyor..." -ForegroundColor Green

# Port kontrolü
$portInUse = Get-NetTCPConnection -LocalPort 50051 -ErrorAction SilentlyContinue

if ($portInUse) {
    Write-Host "UYARI: Port 50051 zaten kullanımda!" -ForegroundColor Yellow
    Write-Host "Process ID: $($portInUse.OwningProcess)" -ForegroundColor Yellow
    
    $response = Read-Host "Mevcut process'i kapatıp devam edilsin mi? (E/H)"
    
    if ($response -eq "E" -or $response -eq "e") {
        Write-Host "Process kapatılıyor..." -ForegroundColor Yellow
        Stop-Process -Id $portInUse.OwningProcess -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    } else {
        Write-Host "İptal edildi." -ForegroundColor Red
        exit
    }
}

# Backend'i başlat
Write-Host "Backend başlatılıyor..." -ForegroundColor Green
go run cmd/aether-server/main.go



