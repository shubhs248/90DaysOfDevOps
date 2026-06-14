#!/bin/bash

echo "Enter Numbers: "
read NUM

while [ $NUM -ge 0 ]
do
	echo $NUM
	NUM=$((NUM-1))
done

echo "Done!"
