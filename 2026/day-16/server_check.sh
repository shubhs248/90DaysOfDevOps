#!/bin/bash

echo "Service name please: "
read SER

echo "Do you want to check its status? Type yes/no: "
read CHOICE

if [ "$CHOICE" = "yes" ]
then
	systemctl status is-enabled $SER

	if systemctl status is-enabled --quiet $SER
	then
		echo "$SER is Active"
	else
		echo "$SER is not Active"
	fi
else
	echo "skipped"
fi
