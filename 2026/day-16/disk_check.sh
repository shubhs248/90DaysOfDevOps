#!/bin/bash

echo "Let's check the disk usage and report if anything Critical"

USAGE = df -h /| awk '{print $1,$2,$5}'

if [ "$USAGE" -ge 80% ]
then
	echo "Warning: FS is over 80% threshold"
elif [ "$USAGE" -ge 90% ]
then
	echo "Critical"
else
	echo "Everything is fine"
fi
