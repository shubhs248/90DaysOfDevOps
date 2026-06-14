#!/bin/bash

echo "Enter your Number:"
read NUM

if [ "$NUM" -gt 0 ]
then
	echo "Number is Positive"
elif [ "$NUM" -lt 0 ]
then
	echo "Number is Negative"
else
	echo "Number is Zero"
fi
