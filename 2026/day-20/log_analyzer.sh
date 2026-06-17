#!/bin/bash

set -euo pipefail
LOGFILE="$1"

if [ $# -eq 0 ]; then
	echo "USAGE: '$0 <file.log>'"
	exit 1
fi

validate_input() {

	if [ -f "$LOGFILE" ]; then
		echo "Analyzing the log file: $LOGFILE"
	else
		echo "File not present"
		exit 1
	fi
}

count_errors() {
	COUNT=$(grep -Eci "ERROR|FAILED" "$LOGFILE")
	echo "Total error count in log file: $COUNT"
}

critical_events() {
	echo
	echo "======================="
	echo "====CRITICAL EVENTS===="
	grep -ni "CRITICAL" "$LOGFILE"
	echo "======================="
}

top_errors() {
	grep -Ei "Error|Failed" "$LOGFILE" | awk '{$1=$2=$3=""; print}'| sort | uniq -c | sort -rn | head -5
}

generate_report() {
	REPORT="log_report_$(date +%Y-%m-%d).txt"
	echo "Log Analysis Report: " > "$REPORT"
	echo "Date: $(date)" >> "$REPORT"
	echo "=====================================" >> "$REPORT"
	echo "Log File: $LOGFILE" >> "$REPORT"
	#Total Lines
	TOTAL=$(wc -l < "$LOGFILE")
	echo "Total Lines: $TOTAL" >> "$REPORT"
	COUNT=$(grep -Eci "ERRORS|FAILED" "$LOGFILE")
	echo "Total errors: $COUNT" >> "$REPORT"
	echo "=====================================" >> "$REPORT"

	TOP=$(grep -Ei "Error|Failed" "$LOGFILE" | awk '{$1=$2=$3=""; print}'| sort | uniq -c | sort -nr | head -5)
	echo "Top errors: $TOP" >> "$REPORT"

	CRIT=$(grep -ni "CRITICAL" "$LOGFILE")
	echo "Critical Errors: $CRIT" >> "$REPORT"

}

archive_log() {
	mkdir -p archive
	mv "$LOGFILE" ./archive
	echo "Log file Archive Successfully"
}

main() {
	validate_input
	count_errors
	critical_events
	top_errors
	generate_report
	archive_log
}

main
