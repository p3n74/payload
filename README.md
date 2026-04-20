# Coolify Payload Simulator

This project hosts a terminal takeover-style animation simulator for demo use.

## Endpoints

- `/` -> `entry.sh` (default launcher for `curl | bash`)
- `/entry.sh` -> shell launcher for macOS/Linux (`bash` or `zsh`)
- `/simulate.sh` -> shell animation script
- `/entry.ps1` -> Windows PowerShell launcher
- `/simulate.ps1` -> Windows PowerShell animation script

## Usage

### macOS/Linux

```bash
curl -fsSL https://payload.citadel-codex.com | bash
```

Optional tuning:

```bash
SIM_SPEED=fast SIM_INTENSITY=high curl -fsSL https://payload.citadel-codex.com | bash
```

### Windows PowerShell

```powershell
iwr https://payload.citadel-codex.com/entry.ps1 -UseBasicParsing | iex
```

## Safety and Behavior

- No persistence is installed.
- No privilege escalation is attempted.
- No system files are changed.
- Temporary files are created only in OS temp paths and removed afterward.
- Terminal state is restored on exit (cursor/colors/alternate screen where supported).

## Coolify Deployment

1. Create a new application in Coolify from this repository.
2. Use `Dockerfile` build mode.
3. Expose port `3045`.
4. Attach your domain: `payload.citadel-codex.com`.
5. Ensure TLS is enabled in Coolify.

## Local Validation

Run these checks before deploy:

```bash
sh -n scripts/entry.sh
sh -n scripts/simulate.sh
sh scripts/simulate.sh
```

If `shellcheck` is installed:

```bash
shellcheck scripts/entry.sh scripts/simulate.sh public/entry.sh public/simulate.sh
```

On Windows, if ScriptAnalyzer is available:

```powershell
Invoke-ScriptAnalyzer .\scripts\entry.ps1, .\scripts\simulate.ps1
```

## Notes

- `scripts/` holds source versions for development.
- `public/` contains files served directly by nginx in the deployed container.
