# .gitignore kontrol script'i
# Hangi dosyalar Git'te olmamalı ama commit edilmiş?

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  .GITIGNORE KONTROL" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Kontrol ediliyor..." -ForegroundColor Yellow

# Git'te olan dosyaları kontrol et
$gitFiles = git ls-files

$issues = @()

# Protobuf dosyaları kontrol et
$pbFiles = $gitFiles | Where-Object { $_ -like "*.pb.go" -or $_ -like "*_grpc.pb.go" }
if ($pbFiles.Count -gt 0) {
    $issues += "Proto dosyaları Git'te:"
    $pbFiles | ForEach-Object { $issues += "  - $_" }
}

# Build dosyaları kontrol et
$buildDirs = @("bin/", "build/", "dist/")
foreach ($dir in $buildDirs) {
    $files = $gitFiles | Where-Object { $_ -like "$dir*" }
    if ($files.Count -gt 0) {
        $issues += "$dir içinde Git'te olan dosyalar:"
        $files | ForEach-Object { $issues += "  - $_" }
    }
}

# Database dosyaları kontrol et
$dbFiles = $gitFiles | Where-Object { $_ -like "*.db" -or $_ -like "*.bolt" -or $_ -like "*.sqlite*" }
if ($dbFiles.Count -gt 0) {
    $issues += "Veritabanı dosyaları Git'te:"
    $dbFiles | ForEach-Object { $issues += "  - $_" }
}

# Binary dosyalar kontrol et (exe, dll, etc.)
$binaryFiles = $gitFiles | Where-Object { 
    $_ -like "*.exe" -or $_ -like "*.dll" -or $_ -like "*.so" -or 
    $_ -like "*.bin" -or $_ -like "aether-server.exe"
}
if ($binaryFiles.Count -gt 0) {
    $issues += "Binary dosyalar Git'te:"
    $binaryFiles | ForEach-Object { $issues += "  - $_" }
}

# Data/chunks klasörü (bin chunk storage, kod dosyaları değil)
$chunkFiles = $gitFiles | Where-Object { 
    $_ -like "chunks/*" -or 
    ($_ -like "*chunks/*" -and $_ -notlike "cmd/*" -and $_ -notlike "*.go")
}
if ($chunkFiles.Count -gt 0) {
    $issues += "Chunk storage dosyaları Git'te:"
    $chunkFiles | ForEach-Object { $issues += "  - $_" }
}

# .aether klasörü
$aetherFiles = $gitFiles | Where-Object { $_ -like ".aether/*" }
if ($aetherFiles.Count -gt 0) {
    $issues += ".aether klasörü Git'te:"
    $aetherFiles | ForEach-Object { $issues += "  - $_" }
}

# Test dosyaları
$testFiles = $gitFiles | Where-Object { $_ -like "*test*.txt" }
if ($testFiles.Count -gt 0) {
    $issues += "Test dosyaları Git'te:"
    $testFiles | ForEach-Object { $issues += "  - $_" }
}

# Sonuçları göster
if ($issues.Count -eq 0) {
    Write-Host "✅ .gitignore doğru! Git'te olmaması gereken dosya yok." -ForegroundColor Green
    Write-Host "========================================`n" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "❌ .gitignore ile uyuşmayan dosyalar bulundu:" -ForegroundColor Red
    Write-Host ""
    $issues | ForEach-Object { Write-Host $_ -ForegroundColor White }
    Write-Host ""
    Write-Host "⚠️  Bu dosyalar Git'ten kaldırılmalı!" -ForegroundColor Yellow
    Write-Host "========================================`n" -ForegroundColor Cyan
    exit 1
}

