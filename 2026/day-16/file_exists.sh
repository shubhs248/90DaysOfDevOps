#!/bin/bash

echo "File name? PLease enter:"
read FILE

if [ -f "$FILE" ]
then
	echo "File exists"
else
	echo "File not found"
fi
