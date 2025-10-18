# Flutter proto generation script

Write-Host "Flutter icin proto dosyalari generate ediliyor..." -ForegroundColor Cyan

# Proto dizini
$protoDir = "api/proto"
$outputDir = "flutter_ui/lib/generated"

# Google protobuf include path
# Windows'ta genellikle Go modules cache'inde bulunur
$goPath = go env GOMODCACHE
$protobufPath = Get-ChildItem -Path "$goPath/google.golang.org/protobuf@*" -Directory | Select-Object -First 1

if ($protobufPath) {
    Write-Host "Protobuf path: $protobufPath" -ForegroundColor Cyan
}

# Tum proto dosyalarini compile et
$protoFiles = @(
    "common.proto",
    "folder.proto",
    "file.proto",
    "chunk.proto",
    "peer.proto",
    "p2p.proto",
    "sync.proto",
    "auth.proto"
)

foreach ($file in $protoFiles) {
    $protoPath = Join-Path $protoDir $file
    
    if (Test-Path $protoPath) {
        Write-Host "Generating: $file" -ForegroundColor Yellow
        
        # Include path ekle
        $includeArgs = "-I. -Iapi/proto"
        
        $cmd = "protoc --dart_out=grpc:$outputDir $includeArgs $protoPath"
        Invoke-Expression $cmd
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "OK: $file generated" -ForegroundColor Green
        } else {
            Write-Host "ERROR: $file failed" -ForegroundColor Red
        }
    } else {
        Write-Host "WARNING: $file not found" -ForegroundColor DarkYellow
    }
}

Write-Host ""
Write-Host "Proto generation tamamlandi!" -ForegroundColor Green
Write-Host "Konum: $outputDir" -ForegroundColor Cyan
