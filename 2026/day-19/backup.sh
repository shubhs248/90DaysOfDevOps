#!/bin/bash

set -euo pipefail

#Validation

#Variable

SOURCE="/mnt/c/Users/logs"
DESTINATION="/mnt/c/Users/backup"
DATE=$(date +%Y-%m-%d-%H-%M-%S)
ARCHIVE="$DESTINATION/backup-$DATE.tar.gz"

check_dirs(){

	if [ ! -d "$SOURCE" ]; then
		echo "Source dir not present"
		exit 1
	fi

	if [ ! -d "$DESTINATION" ]; then
		echo "Destination dir not present"
		exit 1
	fi

}

create_backup(){

	echo "Creating backup"
	tar -czf "$ARCHIVE" "$SOURCE"

}

verify_backup(){

	if [ -f "$ARCHIVE" ]; then
		echo "Backup created successfully"

		ls -lh "$ARCHIVE"

	else
		echo "Backup Failed"
		exit 1
	fi

}

clean_old_backup(){

	OLD_BACKUPS=$(find "$DESTINATION" -name "*.tar.gz" -mtime +14 | wc -l)

	find "$DESTINATION" -name "*.tar.gz" -mtime +14 -delete
	echo "Deleted $OLD_BACKUPS old backups"

}

main(){

	check_dirs
	create_backup
	verify_backup
	clean_old_backup
	echo "Old backup completed successfully"

}

main
