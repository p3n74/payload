#!/usr/bin/env sh

set -eu

tmp_dir=""

cleanup() {
  if command -v tput >/dev/null 2>&1; then
    tput cnorm >/dev/null 2>&1 || true
    tput sgr0 >/dev/null 2>&1 || true
    tput rmcup >/dev/null 2>&1 || true
  fi
  if [ -n "$tmp_dir" ] && [ -d "$tmp_dir" ]; then
    rm -rf "$tmp_dir"
  fi
  printf "\n"
}

trap cleanup EXIT INT TERM

if command -v tput >/dev/null 2>&1; then
  tput civis >/dev/null 2>&1 || true
  tput smcup >/dev/null 2>&1 || true
fi

tmp_dir="$(mktemp -d 2>/dev/null || mktemp -d -t payloadsim)"
sim_file="$tmp_dir/simulate.sh"

BASE_URL="${PAYLOAD_BASE_URL:-https://payload.citadel-codex.com}"
SIM_URL="$BASE_URL/simulate.sh"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$SIM_URL" -o "$sim_file"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$sim_file" "$SIM_URL"
else
  printf "error: curl or wget is required\n" >&2
  exit 1
fi

chmod 700 "$sim_file"
sh "$sim_file"
