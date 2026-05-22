#!/bin/bash

# ─────────────────────────────────────────────
#  server-stats.sh — Basic Server Performance
# ─────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

divider() {
  echo -e "${CYAN}──────────────────────────────────────────────────${RESET}"
}

header() {
  echo ""
  divider
  echo -e "  ${BOLD}${YELLOW}$1${RESET}"
  divider
}

# ── Header Banner ──────────────────────────────
clear
echo -e "${BOLD}${CYAN}"
echo "  ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ "
echo "  ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗"
echo "  ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝"
echo "  ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗"
echo "  ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║"
echo "  ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝"
echo -e "            ${RESET}${BOLD}S T A T S   R E P O R T${RESET}"
echo ""
echo -e "  ${GREEN}Generated:${RESET} $(date '+%A, %d %B %Y  %H:%M:%S %Z')"
echo -e "  ${GREEN}Hostname :${RESET} $(hostname)"

# ── 1. OS & Uptime ─────────────────────────────
header "SYSTEM INFORMATION"

OS=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || uname -o)
KERNEL=$(uname -r)
ARCH=$(uname -m)
UPTIME_STR=$(uptime -p 2>/dev/null || uptime)
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs)

printf "  %-18s %s\n" "OS:"        "$OS"
printf "  %-18s %s\n" "Kernel:"    "$KERNEL"
printf "  %-18s %s\n" "Arch:"      "$ARCH"
printf "  %-18s %s\n" "Uptime:"    "$UPTIME_STR"
printf "  %-18s %s\n" "Load Avg:"  "$LOAD"

# ── 2. CPU Usage ───────────────────────────────
header " CPU USAGE"

CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | tr -d '%')
# Fallback for different top formats
if [ -z "$CPU_IDLE" ]; then
  CPU_IDLE=$(top -bn1 | grep "%Cpu" | awk '{print $8}')
fi
CPU_USED=$(awk "BEGIN {printf \"%.1f\", 100 - ${CPU_IDLE:-0}}")
CPU_CORES=$(nproc)

# Build a simple bar
BAR_LEN=40
FILLED=$(awk "BEGIN {printf \"%d\", ($CPU_USED/100)*$BAR_LEN}")
EMPTY=$((BAR_LEN - FILLED))
BAR="${GREEN}$(printf '█%.0s' $(seq 1 $FILLED 2>/dev/null))${RESET}$(printf '░%.0s' $(seq 1 $EMPTY 2>/dev/null))"

printf "  %-18s %s\n"  "CPU Cores:"   "$CPU_CORES"
printf "  %-18s %.1f%%\n" "Used:"     "$CPU_USED"
printf "  %-18s %.1f%%\n" "Idle:"     "$CPU_IDLE"
echo -e "  [${BAR}] ${BOLD}${CPU_USED}%${RESET}"

# ── 3. Memory Usage ────────────────────────────
header " MEMORY USAGE"

MEM_INFO=$(free -m)
MEM_TOTAL=$(echo "$MEM_INFO" | awk '/^Mem:/{print $2}')
MEM_USED=$(echo  "$MEM_INFO" | awk '/^Mem:/{print $3}')
MEM_FREE=$(echo  "$MEM_INFO" | awk '/^Mem:/{print $4}')
MEM_AVAIL=$(echo "$MEM_INFO" | awk '/^Mem:/{print $7}')
MEM_PCT=$(awk "BEGIN {printf \"%.1f\", ($MEM_USED/$MEM_TOTAL)*100}")

SWAP_TOTAL=$(echo "$MEM_INFO" | awk '/^Swap:/{print $2}')
SWAP_USED=$(echo  "$MEM_INFO" | awk '/^Swap:/{print $3}')
SWAP_FREE=$(echo  "$MEM_INFO" | awk '/^Swap:/{print $4}')

FILLED=$(awk "BEGIN {printf \"%d\", ($MEM_PCT/100)*$BAR_LEN}")
EMPTY=$((BAR_LEN - FILLED))
BAR="${YELLOW}$(printf '█%.0s' $(seq 1 $FILLED 2>/dev/null))${RESET}$(printf '░%.0s' $(seq 1 $EMPTY 2>/dev/null))"

printf "  %-18s %s MB\n" "Total:"     "$MEM_TOTAL"
printf "  %-18s %s MB\n" "Used:"      "$MEM_USED"
printf "  %-18s %s MB\n" "Free:"      "$MEM_FREE"
printf "  %-18s %s MB\n" "Available:" "$MEM_AVAIL"
echo -e "  [${BAR}] ${BOLD}${MEM_PCT}%${RESET}"
echo ""
printf "  %-18s %s MB / %s MB used\n" "Swap:" "$SWAP_USED" "$SWAP_TOTAL"

# ── 4. Disk Usage ──────────────────────────────
header "💾  DISK USAGE"

printf "  %-20s %8s %8s %8s %6s  %s\n" "Filesystem" "Total" "Used" "Free" "Use%" "Mounted"
divider
df -h --output=source,size,used,avail,pcent,target 2>/dev/null | tail -n +2 | grep -v tmpfs | grep -v udev | while IFS= read -r line; do
  PCT=$(echo "$line" | awk '{print $5}' | tr -d '%')
  if [ "$PCT" -ge 90 ] 2>/dev/null; then COLOR=$RED
  elif [ "$PCT" -ge 70 ] 2>/dev/null; then COLOR=$YELLOW
  else COLOR=$GREEN; fi
  echo -e "  ${COLOR}$(printf '%-20s %8s %8s %8s %6s%%  %s' $line)${RESET}"
done

# ── 5. Top 5 by CPU ────────────────────────────
header " TOP 5 PROCESSES BY CPU"

printf "  %-8s %-10s %6s %6s  %s\n" "PID" "USER" "CPU%" "MEM%" "COMMAND"
divider
ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {printf "  %-8s %-10s %6s %6s  %s\n", $2, $1, $3, $4, $11}'

# ── 6. Top 5 by Memory ─────────────────────────
header " TOP 5 PROCESSES BY MEMORY"

printf "  %-8s %-10s %6s %6s  %s\n" "PID" "USER" "CPU%" "MEM%" "COMMAND"
divider
ps aux --sort=-%mem | awk 'NR>1 && NR<=6 {printf "  %-8s %-10s %6s %6s  %s\n", $2, $1, $3, $4, $11}'

# ── 7. Logged-in Users ─────────────────────────
header "LOGGED IN USERS"

USERS=$(who | wc -l)
printf "  %-18s %s\n" "Active sessions:" "$USERS"
echo ""
who | awk '{printf "  %-15s %-10s %s %s\n", $1, $2, $3, $4}'

# ── 8. Failed Login Attempts ───────────────────
header "FAILED LOGIN ATTEMPTS"

if [ -r /var/log/auth.log ]; then
  FAILS=$(grep -c "Failed password" /var/log/auth.log 2>/dev/null || echo 0)
  printf "  %-18s %s\n" "Total failures:" "$FAILS"
  echo ""
  echo -e "  ${BOLD}Top offending IPs:${RESET}"
  grep "Failed password" /var/log/auth.log 2>/dev/null \
    | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    | sort | uniq -c | sort -rn | head -5 \
    | awk '{printf "    %5s attempts  —  %s\n", $1, $2}'
elif [ -r /var/log/secure ]; then
  FAILS=$(grep -c "Failed password" /var/log/secure 2>/dev/null || echo 0)
  printf "  %-18s %s\n" "Total failures:" "$FAILS"
  grep "Failed password" /var/log/secure 2>/dev/null \
    | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    | sort | uniq -c | sort -rn | head -5 \
    | awk '{printf "    %5s attempts  —  %s\n", $1, $2}'
else
  echo -e "  ${YELLOW}Log file not readable (try running with sudo)${RESET}"
fi

# ── Footer ─────────────────────────────────────
echo ""
divider
echo -e "  ${BOLD}${GREEN}✓ Report complete${RESET}"
divider
echo ""