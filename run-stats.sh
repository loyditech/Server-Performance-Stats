#!/bin/bash
LOGDIR="$HOME/logs/server-stats"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOGFILE="$LOGDIR/report-$TIMESTAMP.log"

echo "=== Server Stats Report ===" > "$LOGFILE"
echo "Generated: $(date)" >> "$LOGFILE"
echo "" >> "$LOGFILE"

bash /home/mark/server-stats/server-stats.sh >> "$LOGFILE" 2>&1

# Keep only last 12 reports
ls -t "$LOGDIR"/report-*.log | tail -n +13 | xargs rm -f 2>/dev/null
