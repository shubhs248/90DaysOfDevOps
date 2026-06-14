#!/bin/bash

echo "Disk usage"

USAGE=$(df -h /| awk 'NR==2 {gsub("%","",$5); print $5}')

echo "Current Usage: $USAGE%"

if [ "$USAGE" -ge 90 ]
then
	echo "CRITICAL"
elif [ "$USAGE" -ge 80 ]
then
	echo "WARNING"
else
	echo "Everything is fine"
fi
