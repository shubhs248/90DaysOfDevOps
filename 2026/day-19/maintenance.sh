#!/bin/bash

set -euo pipefail

LOGFILE="/tmp/maintenance.log"
echo "===$(date)===" >> "$LOGFILE"

./log_rotate.sh /mnt/c/Users/logs >> "$LOGFILE" 2>&1

./backup.sh >> "$LOGFILE" 2>&1

echo "Maintenance Completed" >> "$LOGFILE"
