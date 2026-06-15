#!/bin/bash

set -euo pipefail

system_info() {
	
	echo "============="
	echo "SYS INFO"
	echo "============="
	
	echo "Hostname: $(hostname)"

	echo "OS: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2)"
}

uptime_info() {

	echo 
	echo "==================="
	echo "UPTIME"
	echo "==================="

	uptime

}

disk_info() {

	echo
	echo "=============="
	echo "DISK USAGE"
	echo "=============="

	df -h | head -5
}


memory_info() {

	echo
	echo "====================="
	echo "MEMORY"
	echo "====================="

	free -h
	
}

cpu_info() {

	echo
	echo "================="
	echo "TOP CPU process"
	echo "================="

	ps aux --sort=-%cpu| head
}

main() {

	system_info
	uptime_info
	disk_info
	memory_info
	cpu_info

}

main
