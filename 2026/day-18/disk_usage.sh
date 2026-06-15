#!/bin/bash

check_disk() {
	echo "===== DISK ====="
	df -h
}

check_memory() {
	echo "===== Memory ====="
	free -h
}

check_disk

check_memory
