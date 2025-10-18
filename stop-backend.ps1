# Stop Aether Backend

Write-Host "Stopping Aether Backend..." -ForegroundColor Yellow

$portInUse = Get-NetTCPConnection -LocalPort 50051 -ErrorAction SilentlyContinue

if ($portInUse) {
    $pid = $portInUse.OwningProcess
    Write-Host "Process found: PID $pid" -ForegroundColor Green
    
    Stop-Process -Id $pid -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    
    $stillRunning = Get-Process -Id $pid -ErrorAction SilentlyContinue
    
    if ($stillRunning) {
        Write-Host "Force stopping..." -ForegroundColor Red
        Stop-Process -Id $pid -Force
    }
    
    Write-Host "Backend stopped!" -ForegroundColor Green
} else {
    Write-Host "No process found on port 50051" -ForegroundColor Yellow
}
