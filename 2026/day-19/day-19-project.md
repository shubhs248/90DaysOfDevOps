# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

## 🎯 Objective

Apply Shell Scripting concepts learned in Days 16–18 by building real-world automation scripts.

---

# Task 1 – Log Rotation Script

## File

`log_rotate.sh`

## Features

* Accepts log directory as an argument.
* Validates if the directory exists.
* Counts total `.log` files.
* Compresses `.log` files older than 7 days using `gzip`.
* Deletes compressed `.gz` files older than 30 days.
* Displays the number of compressed and deleted files.
* Uses functions and `set -euo pipefail` for better scripting practices.

### Sample Run

```bash
./log_rotate.sh ./logs

Found 5 log files
Compressing 2 old log files...
Deleting 1 compressed log older than 30 days
Success: Log rotation completed
```

---

# Task 2 – Server Backup Script

## File

`backup.sh`

## Features

* Validates source and destination directories.
* Creates timestamped backups.

Example:

```
backup-2026-06-16-11-52-24.tar.gz
```

* Compresses using `tar -czf`
* Verifies backup creation.
* Displays archive details.
* Deletes backups older than 14 days.

### Sample Run

```bash
./backup.sh

Creating backup...
Backup created successfully

-rw-r--r-- backup-2026-06-16-11-52-24.tar.gz

Deleted 0 old backups

Backup completed successfully
```

---

# Task 3 – Crontab

## Current Cron Jobs

```bash
crontab -l
```

## Daily Log Rotation (2:00 AM)

```cron
0 2 * * * /path/to/log_rotate.sh /var/log
```

## Weekly Backup (Sunday 3:00 AM)

```cron
0 3 * * 0 /path/to/backup.sh /source /backup
```

## Health Check Every 5 Minutes

```cron
*/5 * * * * /path/to/health_check.sh
```

---

# Task 4 – Scheduled Maintenance

## File

`maintenance.sh`

## Features

* Runs Log Rotation Script.
* Runs Backup Script.
* Redirects all output to:

```
/tmp/maintenance.log
```

using

```bash
>> /tmp/maintenance.log 2>&1
```

### Daily Maintenance Cron

```cron
0 1 * * * /path/to/maintenance.sh
```

---

# Commands Used

```bash
find
gzip
tar
wc
date
ls
du
crontab
```

---

# Concepts Learned

* Shell scripting project structure
* Functions and reusable code
* Directory validation
* File validation
* Log rotation using `find`
* File compression using `gzip`
* Archive creation using `tar`
* Timestamped backups
* Cleaning old files using `-mtime`
* Logging output using `2>&1`
* Scheduling automation with `cron`
* Error handling with `set -euo pipefail`

---

# Project Structure

```
day-19/
│
├── backup.sh
├── log_rotate.sh
├── maintenance.sh
├── logs/
├── backup/
└── day-19-project.md
```

---

# Key Takeaways

* Built my first end-to-end Shell Scripting automation project.
* Automated log rotation and backup processes.
* Learned how Linux servers automate repetitive tasks using Cron Jobs.
* Improved scripting with functions, validation, logging, and strict mode.
* This project closely resembles real-world DevOps automation tasks.
