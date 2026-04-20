$ErrorActionPreference = "Stop"

param(
    [ValidateSet("fast","normal","slow")]
    [string]$Speed = "normal",
    [ValidateSet("low","normal","high")]
    [string]$Intensity = "normal"
)

function Get-Delay {
    param([string]$Kind)
    switch ($Speed) {
        "fast"   { if ($Kind -eq "step") { return 20 } else { return 60 } }
        "slow"   { if ($Kind -eq "step") { return 120 } else { return 180 } }
        default  { if ($Kind -eq "step") { return 60 } else { return 100 } }
    }
}

function Write-Phase {
    param([string]$Text, [ConsoleColor]$Color = [ConsoleColor]::Gray)
    $previous = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Host $Text
    $Host.UI.RawUI.ForegroundColor = $previous
    Start-Sleep -Milliseconds (Get-Delay -Kind "step")
}

function Show-ProgressBar {
    param([string]$Label)
    for ($i = 0; $i -le 100; $i += 5) {
        Write-Progress -Activity $Label -Status "$i% complete" -PercentComplete $i
        Start-Sleep -Milliseconds (Get-Delay -Kind "block")
    }
    Write-Progress -Activity $Label -Completed
}

function Show-Glitch {
    $loops = switch ($Intensity) {
        "high" { 22 }
        "low" { 8 }
        default { 14 }
    }

    for ($i = 0; $i -lt $loops; $i++) {
        $stamp = Get-Date -Format "HH:mm:ss"
        $value = ($i * 13) % 97
        Write-Phase "$stamp :: signal drift :: $value-0x$($i * 257)" -Color Magenta
    }
}

$hostName = [Environment]::MachineName
$userName = [Environment]::UserName

Write-Phase "establishing terminal control plane..." -Color Cyan
Write-Phase "target host: $hostName" -Color Yellow
Write-Phase "session owner: $userName" -Color Yellow
Write-Phase "loading volatile modules..." -Color Blue
Show-ProgressBar "kernel bridge sync"
Show-ProgressBar "memory map shadow"
Write-Phase "intercepting io stream" -Color Red
Show-Glitch
Write-Phase "routing pseudo telemetry" -Color Yellow
Show-ProgressBar "satellite uplink"
Write-Phase "injecting visual noise matrix" -Color Magenta
Show-Glitch
Write-Phase "control asserted" -Color Green
Write-Phase "releasing session in 3..." -Color Cyan
Start-Sleep -Milliseconds 400
Write-Phase "2..." -Color Cyan
Start-Sleep -Milliseconds 400
Write-Phase "1..." -Color Cyan
Start-Sleep -Milliseconds 400
Write-Phase "session restored" -Color Green
