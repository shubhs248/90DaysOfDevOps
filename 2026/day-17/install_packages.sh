#!/bin/bash

packages="nginx curl wget"

if [ "$EUID" -ne 0 ]
then
	echo "Please run as root only, exiting ..."
	exit 1
fi

for package in $packages
do
	dpkg -s $package > /dev/null 2>&1

	if [ $? -eq 0 ]
	then
		echo "$package already installed"
	else
		echo "Installing $package ..."
		apt install -y $package
	fi
done
