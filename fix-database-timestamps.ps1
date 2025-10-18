# Database timestamp fix script

Write-Host "Aether Veritabani Timestamp Fix" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# SQLite veritabanı yolu
$dbPath = "$env:USERPROFILE\.aether\aether.db"

if (-not (Test-Path $dbPath)) {
    Write-Host "HATA: Veritabani bulunamadi: $dbPath" -ForegroundColor Red
    exit 1
}

Write-Host "Veritabani bulundu: $dbPath" -ForegroundColor Green
Write-Host ""

Write-Host "Timestamp'ler duzeltiliyor..." -ForegroundColor Yellow

# SQL komutları (NULL değerleri için fallback ekle)
$sql1 = @"
UPDATE files 
SET mod_time = COALESCE(
    CASE 
        WHEN typeof(mod_time) = 'text' THEN CAST(strftime('%s', mod_time) AS INTEGER)
        ELSE mod_time
    END,
    CAST(strftime('%s', 'now') AS INTEGER)
),
created_at = COALESCE(
    CASE 
        WHEN typeof(created_at) = 'text' THEN CAST(strftime('%s', created_at) AS INTEGER)
        ELSE created_at
    END,
    CAST(strftime('%s', 'now') AS INTEGER)
),
updated_at = COALESCE(
    CASE 
        WHEN typeof(updated_at) = 'text' THEN CAST(strftime('%s', updated_at) AS INTEGER)
        ELSE updated_at
    END,
    CAST(strftime('%s', 'now') AS INTEGER)
)
WHERE typeof(mod_time) = 'text' OR typeof(created_at) = 'text' OR typeof(updated_at) = 'text';
"@

$sql2 = @"
UPDATE folders 
SET last_scan_time = COALESCE(
    CASE 
        WHEN typeof(last_scan_time) = 'text' THEN CAST(strftime('%s', last_scan_time) AS INTEGER)
        ELSE last_scan_time
    END,
    CAST(strftime('%s', 'now') AS INTEGER)
),
created_at = COALESCE(
    CASE 
        WHEN typeof(created_at) = 'text' THEN CAST(strftime('%s', created_at) AS INTEGER)
        ELSE created_at
    END,
    CAST(strftime('%s', 'now') AS INTEGER)
),
updated_at = COALESCE(
    CASE 
        WHEN typeof(updated_at) = 'text' THEN CAST(strftime('%s', updated_at) AS INTEGER)
        ELSE updated_at
    END,
    CAST(strftime('%s', 'now') AS INTEGER)
)
WHERE typeof(last_scan_time) = 'text' OR typeof(created_at) = 'text' OR typeof(updated_at) = 'text';
"@

# sqlite3 komutu ile çalıştır
Write-Host "  - Files tablosu guncelleniyor..." -ForegroundColor Yellow
sqlite3 $dbPath $sql1

if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK: Files tablosu guncellendi" -ForegroundColor Green
} else {
    Write-Host "  HATA: Files tablosu guncellenemedi" -ForegroundColor Red
}

Write-Host "  - Folders tablosu guncelleniyor..." -ForegroundColor Yellow
sqlite3 $dbPath $sql2

if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK: Folders tablosu guncellendi" -ForegroundColor Green
} else {
    Write-Host "  HATA: Folders tablosu guncellenemedi" -ForegroundColor Red
}

Write-Host ""
Write-Host "OK: Timestamp fix tamamlandi!" -ForegroundColor Green
Write-Host ""
Write-Host "Backend'i yeniden baslatabilirsiniz: .\start-backend.ps1" -ForegroundColor Cyan
