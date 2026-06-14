#!/bin/bash

systemctl is-active --quiet "$1" 2>/dev/null

if [ $? -eq 0 ]
then
	echo "Service is enabled"
else
	echo "Service is not enabled"
fi
