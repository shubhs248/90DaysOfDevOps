#!/bin/bash

echo "Enter your age please, right here: "
read AGE

if [ "$AGE" -ge 18 ]
then
	echo "You're an adult now, Son"
else
	echo "Nah, Still the wetty boy you are"
fi
