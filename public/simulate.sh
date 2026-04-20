#!/usr/bin/env sh

set -u

SPEED="${SIM_SPEED:-1}"
INTENSITY="${SIM_INTENSITY:-1}"

if [ "$SPEED" = "fast" ]; then
  STEP_DELAY="0.03"
  BLOCK_DELAY="0.08"
elif [ "$SPEED" = "slow" ]; then
  STEP_DELAY="0.12"
  BLOCK_DELAY="0.2"
else
  STEP_DELAY="0.07"
  BLOCK_DELAY="0.12"
fi

if [ "$INTENSITY" = "high" ]; then
  GLITCH_LOOPS=20
elif [ "$INTENSITY" = "low" ]; then
  GLITCH_LOOPS=8
else
  GLITCH_LOOPS=12
fi

if command -v tput >/dev/null 2>&1; then
  RED="$(tput setaf 1 2>/dev/null || true)"
  GREEN="$(tput setaf 2 2>/dev/null || true)"
  YELLOW="$(tput setaf 3 2>/dev/null || true)"
  BLUE="$(tput setaf 4 2>/dev/null || true)"
  MAGENTA="$(tput setaf 5 2>/dev/null || true)"
  CYAN="$(tput setaf 6 2>/dev/null || true)"
  BOLD="$(tput bold 2>/dev/null || true)"
  RESET="$(tput sgr0 2>/dev/null || true)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  MAGENTA=""
  CYAN=""
  BOLD=""
  RESET=""
fi

sleep_brief() {
  sleep "$1" 2>/dev/null || sleep 1
}

line() {
  printf "%s\n" "$1"
  sleep_brief "$STEP_DELAY"
}

progress() {
  label="$1"
  i=0
  printf "%s" "$label"
  while [ "$i" -le 100 ]; do
    filled=$((i / 4))
    bar=""
    j=0
    while [ "$j" -lt "$filled" ]; do
      bar="${bar}#"
      j=$((j + 1))
    done
    printf "\r%s [%-30s] %3s%%" "$label" "$bar" "$i"
    i=$((i + 5))
    sleep_brief "$BLOCK_DELAY"
  done
  printf "\n"
}

glitch_block() {
  c=0
  while [ "$c" -lt "$GLITCH_LOOPS" ]; do
    printf "%s%s%s%s%s%s\n" \
      "$MAGENTA" \
      "$(date +%H:%M:%S 2>/dev/null || printf "00:00:00")" \
      " :: signal drift :: " \
      "$(( (c * 13) % 97 ))" \
      "-0x$(( (c * 11) % 65535 ))" \
      "$RESET"
    c=$((c + 1))
    sleep_brief "$STEP_DELAY"
  done
}

run_simulation() {
  host="$(hostname 2>/dev/null || printf "device")"
  user_name="${USER:-operator}"

  line "${CYAN}${BOLD}establishing terminal control plane...${RESET}"
  line "${YELLOW}target host:${RESET} ${host}"
  line "${YELLOW}session owner:${RESET} ${user_name}"
  line "${BLUE}loading volatile modules...${RESET}"
  progress "${GREEN}kernel bridge sync${RESET}"
  progress "${GREEN}memory map shadow${RESET}"
  line "${RED}${BOLD}intercepting io stream${RESET}"
  glitch_block
  line "${YELLOW}routing pseudo telemetry${RESET}"
  progress "${CYAN}satellite uplink${RESET}"
  line "${MAGENTA}${BOLD}injecting visual noise matrix${RESET}"
  glitch_block
  line "${GREEN}${BOLD}control asserted${RESET}"
  line "${CYAN}releasing session in 3...${RESET}"
  sleep_brief 0.4
  line "${CYAN}2...${RESET}"
  sleep_brief 0.4
  line "${CYAN}1...${RESET}"
  sleep_brief 0.4
  line "${GREEN}session restored${RESET}"
}

run_simulation
