# Transfer proto dosyası kontrol script'i
# Arkadaşının bilgisayarında çalıştırarak proto dosyasının güncel olup olmadığını kontrol edebilir

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  TRANSFER PROTO DOSYASI KONTROL" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

$p2pPbPath = "api/proto/p2p.pb.go"

if (-not (Test-Path $p2pPbPath)) {
    Write-Host "❌ $p2pPbPath dosyasi bulunamadi!" -ForegroundColor Red
    Write-Host "   Proto dosyalarini compile etmemis." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Cozum:" -ForegroundColor Green
    Write-Host "  1. Backend'i durdur (Ctrl+C)" -ForegroundColor White
    Write-Host "  2. Proto dosyalarini compile et:" -ForegroundColor White
    Write-Host "     protoc -I. -Ithird_party --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative api/proto/*.proto" -ForegroundColor Cyan
    Write-Host "  3. Backend'i yeniden baslat" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "✅ $p2pPbPath dosyasi mevcut" -ForegroundColor Green

# TransferInfo, TransferDirection, TransferState kontrolü
$content = Get-Content $p2pPbPath -Raw

if ($content -match "type TransferInfo struct") {
    Write-Host "✅ TransferInfo tipi VAR" -ForegroundColor Green
} else {
    Write-Host "❌ TransferInfo tipi YOK (proto dosyasi eski)" -ForegroundColor Red
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

if ($content -match "TransferDirection") {
    Write-Host "✅ TransferDirection enum VAR" -ForegroundColor Green
} else {
    Write-Host "❌ TransferDirection enum YOK (proto dosyasi eski)" -ForegroundColor Red
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

if ($content -match "TransferState") {
    Write-Host "✅ TransferState enum VAR" -ForegroundColor Green
} else {
    Write-Host "❌ TransferState enum YOK (proto dosyasi eski)" -ForegroundColor Red
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

Write-Host ""
Write-Host "Proto dosyasi guncel!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan
exit 0

