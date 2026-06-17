# Day 20 – Log Analyzer with Bash

## 📌 Objective

Build a real-world Bash script to automate log analysis by:

* Validating user input
* Counting errors
* Finding critical events
* Identifying top recurring errors
* Generating a daily report
* Archiving processed log files

---

## 🛠 Technologies Used

* Bash
* grep
* awk
* sort
* uniq
* head
* wc
* mv
* mkdir

---

## 📂 Project Structure

```
day-20/
│── archive/
│── log/
│── log_analyzer.sh
│── sample.log
│── sample_logs_generator.sh
│── log_report_YYYY-MM-DD.txt
│── README.md
```

---

## 🚀 Features Implemented

### ✅ Input Validation

* Accepts log file as a command-line argument.
* Displays usage if no argument is provided.
* Checks whether the log file exists before processing.

---

### ✅ Error Count

Counts all occurrences of:

* ERROR
* FAILED

using:

```bash
grep -Eci "ERROR|FAILED" logfile
```

---

### ✅ Critical Events

Displays all CRITICAL log entries with line numbers.

Example:

```text
4: 2026-06-17 10:03:30 CRITICAL Disk Full
10: 2026-06-17 10:09:55 CRITICAL Database Connection Lost
```

---

### ✅ Top Error Messages

Extracts error messages using:

* grep
* awk
* sort
* uniq -c
* head

Pipeline used:

```bash
grep -Ei "ERROR|FAILED" "$LOGFILE" \
| awk '{$1=$2=$3=""; print}' \
| sort \
| uniq -c \
| sort -rn \
| head -5
```

Example Output:

```text
3 Database Failed
1 SSH Login
1 Connection Timeout
```

---

### ✅ Summary Report

Generates a report:

```
log_report_YYYY-MM-DD.txt
```

The report includes:

* Analysis Date
* Log File Name
* Total Lines Processed
* Total Error Count
* Top Error Messages
* Critical Events

---

### ✅ Archive Processed Logs

After successful analysis:

* Creates `archive/` directory (if missing)
* Moves processed log file into archive

Example:

```bash
mkdir -p archive
mv "$LOGFILE" archive/
```

---

## 📚 Key Learnings

* Writing modular Bash scripts using functions
* Input validation and error handling
* Using grep with regular expressions
* Processing text using awk
* Sorting and counting duplicate entries
* Generating reports using output redirection
* File and directory management
* Building production-like automation scripts

---

## 💡 Commands Practiced

* grep
* awk
* sort
* uniq
* head
* wc
* mv
* mkdir
* date
* echo
* Output Redirection (`>` and `>>`)

---

## 🎯 Outcome

Built a production-style Bash utility capable of analyzing logs, generating reports, and archiving processed files—similar to basic monitoring and automation tasks performed by Linux/System Administrators and DevOps Engineers.
