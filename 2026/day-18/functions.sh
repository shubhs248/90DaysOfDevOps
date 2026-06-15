#!/bin/bash

greet() {
	echo "Hello, $1!"
}

add() {
	echo $(($1+$2))
}

greet "Shubham"

add 10 20
