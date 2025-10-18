# Aether Database Check Script

$sqlitePath = "$env:USERPROFILE\.aether\aether.db"
$boltdbPath = "$env:USERPROFILE\.aether\aether_config.db"

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Aether Database Check" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# =============================
# SQLite Check
# =============================
Write-Host "SQLite Database (Relational Data)" -ForegroundColor Yellow
Write-Host "---------------------------------" -ForegroundColor Yellow

if (!(Test-Path $sqlitePath)) {
    Write-Host "ERROR: SQLite database not found at $sqlitePath" -ForegroundColor Red
} else {
    Write-Host "OK: Found at $sqlitePath" -ForegroundColor Green
    
    $size = (Get-Item $sqlitePath).Length
    Write-Host "Size: $([math]::Round($size/1KB, 2)) KB" -ForegroundColor White
    Write-Host ""
    
    # Tables
    Write-Host "Tables:" -ForegroundColor Cyan
    sqlite3 $sqlitePath ".tables"
    Write-Host ""
    
    # Counts
    $folderCount = sqlite3 $sqlitePath "SELECT COUNT(*) FROM folders;"
    $fileCount = sqlite3 $sqlitePath "SELECT COUNT(*) FROM files;"
    $userCount = sqlite3 $sqlitePath "SELECT COUNT(*) FROM users;"
    $peerCount = sqlite3 $sqlitePath "SELECT COUNT(*) FROM peers;"
    
    Write-Host "Records:" -ForegroundColor Cyan
    Write-Host "  Folders: $folderCount" -ForegroundColor White
    Write-Host "  Files: $fileCount" -ForegroundColor White
    Write-Host "  Users: $userCount" -ForegroundColor White
    Write-Host "  Peers: $peerCount" -ForegroundColor White
}

Write-Host ""
Write-Host ""

# =============================
# BoltDB Check
# =============================
Write-Host "BoltDB Database (Key-Value Store)" -ForegroundColor Yellow
Write-Host "---------------------------------" -ForegroundColor Yellow

if (!(Test-Path $boltdbPath)) {
    Write-Host "WARNING: BoltDB not found at $boltdbPath" -ForegroundColor Yellow
    Write-Host "Backend has not been started yet or BoltDB is disabled" -ForegroundColor Gray
} else {
    Write-Host "OK: Found at $boltdbPath" -ForegroundColor Green
    
    $size = (Get-Item $boltdbPath).Length
    Write-Host "Size: $([math]::Round($size/1KB, 2)) KB" -ForegroundColor White
    Write-Host ""
    
    Write-Host "BoltDB is a binary format (use test program to inspect)" -ForegroundColor Gray
    Write-Host "Run: go run ./cmd/test-both-db/main.go" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "===================================" -ForegroundColor Green
Write-Host "Check completed!" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
