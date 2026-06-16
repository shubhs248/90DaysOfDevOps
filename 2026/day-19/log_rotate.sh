#!/bin/bash


set -euo pipefail

if [ $# -eq 0 ]; then
	echo "Error: Exiting, Add the path please like ./log_rotate.sh <dir> ..."
	exit 1
fi

DIR=$1

dir_exist() {

if [ ! -d "$DIR" ]; then

	echo "Error: Directory doesn't exist"
	exit 1
fi

}

count_logs(){

	COUNT=$(find "$DIR" -name "*.log" | wc -l)
	echo "Found $COUNT log files"

}


compress_logs(){
	
	OLD_LOGS=$(find "$DIR" -name "*.log" -mtime +7 | wc -l)
	echo "Compressing $OLD_LOGS old log now ..."
	find "$DIR" -name "*.log" -mtime +7 -exec gzip {} \;

}


delete_logs(){
	
	OLD_GZ=$(find "$DIR" -name "*.gz" -mtime +30 | wc -l)
	find "$DIR" -name "*.gz" -mtime +30 -delete
	echo "Deleting $OLD_GZ log which are older than 30 days"
	
}


main() {

	dir_exist "$DIR"
	count_logs 
	compress_logs
	delete_logs
	echo "Success: Log rotation Completed"

}

main
