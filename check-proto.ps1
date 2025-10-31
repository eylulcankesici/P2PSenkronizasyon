# Proto dosyası kontrol script'i
# Arkadaşının bilgisayarında çalıştırarak proto dosyasının güncel olup olmadığını kontrol edebilir

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  PROTO DOSYASI KONTROL" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

$p2pPbPath = "api/proto/p2p.pb.go"

if (-not (Test-Path $p2pPbPath)) {
    Write-Host "❌ $p2pPbPath dosyasi bulunamadi!" -ForegroundColor Red
    Write-Host "   Proto dosyalarini compile etmemis." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Cozum:" -ForegroundColor Green
    Write-Host "  protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host "✅ $p2pPbPath dosyasi mevcut" -ForegroundColor Green

# FileName alanını kontrol et (satır 94'te olmalı)
$line94 = Get-Content $p2pPbPath -TotalCount 94 | Select-Object -Last 1
if ($line94 -match "FileName\s+string.*bytes,8") {
    Write-Host "✅ FileName alani VAR (proto dosyasi guncel)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Proto dosyasi guncel!" -ForegroundColor Green
} else {
    Write-Host "❌ FileName alani YOK (proto dosyasi eski)" -ForegroundColor Red
    Write-Host ""
    Write-Host "PROBLEM: Proto dosyasi guncellenmemis!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Cozum:" -ForegroundColor Green
    Write-Host "  1. Backend'i durdur (Ctrl+C)" -ForegroundColor White
    Write-Host "  2. Proto dosyalarini compile et:" -ForegroundColor White
    Write-Host "     protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto" -ForegroundColor Cyan
    Write-Host "  3. Backend'i yeniden baslat" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "========================================`n" -ForegroundColor Cyan
exit 0

