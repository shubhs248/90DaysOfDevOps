# Day 06 – Linux Fundamentals: File I/O Operations

**Date:** June 6, 2026  
**System:** WSL (Ubuntu on Windows Subsystem Linux)

## Overview

This practice session focuses on fundamental file input/output (I/O) operations:
- Creating and writing text files
- Understanding redirection operators (`>` and `>>`)
- Reading file contents with `cat`
- Partial file reading with `head` and `tail`
- Combining commands with piping (`|`)
- Using `tee` command for simultaneous write and display
- File analysis with `wc` command

---

## 1. Creating and Writing Files

### 1.1 Initial File Creation

**Objective:** Create an empty file and add content via redirection

**Command:** `touch notes.txt`

**Purpose:** Creates an empty file named `notes.txt`

---

### 1.2 Writing First Line with Redirection

**Command:** `echo "This is how you push a single string to file" >> notes.txt`

**Output:**
```
(no output - appended to file)
```

**Key Learning:**
- `>>` operator **appends** content to a file (creates if doesn't exist)
- `>` operator would **overwrite** the entire file (use with caution!)
- Using `>>` for the first write is safe

---

### 1.3 Adding More Lines

**Command 1:** `echo "This should append to the next line" >> notes.txt`

**Command 2:** `echo "will later use it to practice display single line through other commands" >> notes.txt`

**Verification:**
```bash
$ cat notes.txt
This is how you push a single string to file
This should append to the next line
will later use it to practice display single line through other commands
```

**Observations:**
- Each `echo` statement creates a new line
- Content stacks vertically in the file

---

## 2. Advanced Writing with tee

### 2.1 Using tee to Write and Display Simultaneously

**Command:** `echo "using tee command to push it altogether" | tee -a notes.txt`

**Output:**
```
using tee command to push it altogether
```

**File Content After:**
```
This is how you push a single string to file
This should append to the next line
will later use it to practice display single line through other commands
using tee command to push it altogether
```

**Key Benefits of tee:**
- Displays output to terminal AND writes to file simultaneously
- `-a` flag appends (instead of overwriting)
- Useful for logging command outputs in real-time
- Great for scripts that need to show progress while recording

---

## 3. Reading Files - Full and Partial Content

### 3.1 Reading Entire File Content

**Command:** `cat notes.txt`

**Output:**
```
This is how you push a single string to file
This should append to the next line
will later use it to practice display single line through other commands
using tee command to push it altogether
```

**Use Case:**
- Quick verification of file contents
- Useful for small to medium-sized files
- For large files, causes terminal overflow

---

### 3.2 Reading First N Lines with head

**Command 1:** `head -n 3 notes.txt`

**Output:**
```
This is how you push a single string to file
This should append to the next line
will later use it to practice display single line through other commands
```

**Command 2:** `head -n 5 notes.txt`

**Output:**
```
This is how you push a single string to file
This should append to the next line
will later use it to practice display single line through other commands
using tee command to push it altogether
```

**Key Learning:**
- `head -n N` shows first N lines
- Useful for log file previews
- Default (without `-n`) shows first 10 lines
- Helps avoid displaying entire large files

---

## 4. File Analysis Commands

### 4.1 Counting File Metrics

**Command 1: Count Lines**
```bash
$ wc -l notes.txt
4 notes.txt
```

**Command 2: Count Words**
```bash
$ wc -w notes.txt
36 notes.txt
```

**Command 3: File Size in Human-Readable Format**
```bash
$ ls -lh notes.txt
-rwxrwxrwx 1 root root 194 Jun  6 16:40 notes.txt
```

**Metrics Summary:**
| Metric | Value | Meaning |
|--------|-------|---------|
| Lines | 4 | Total number of lines in the file |
| Words | 36 | Total number of words across all lines |
| Size | 194 bytes | Total file size on disk |
| Permissions | rwxrwxrwx | Read/Write/Execute for all users |

---

## 5. Common Redirection Operators

| Operator | Purpose | Example | Behavior |
|----------|---------|---------|----------|
| `>` | Redirect/Write | `echo "text" > file.txt` | **Overwrites** entire file (destructive!) |
| `>>` | Append | `echo "text" >> file.txt` | **Appends** to end of file (safe) |
| `\|` | Pipe | `cat file.txt \| grep "word"` | Passes output as input to next command |
| `tee` | T-junction | `echo "text" \| tee -a file.txt` | Writes AND displays simultaneously |

**⚠️ Critical Warning:**
- Never use `>` on existing files unless you want to erase them
- Always use `>>` for appending to preserve existing content

---

## 6. Command Workflow Summary

```bash
# Step 1: Create empty file
touch notes.txt

# Step 2: Write first line (append is safe here)
echo "Line 1" >> notes.txt

# Step 3: Add more content
echo "Line 2" >> notes.txt
echo "Line 3" >> notes.txt

# Step 4: View full file
cat notes.txt

# Step 5: View top lines
head -n 2 notes.txt

# Step 6: Write and display simultaneously
echo "Line 4" | tee -a notes.txt

# Step 7: Get file statistics
wc -l notes.txt
wc -w notes.txt
ls -lh notes.txt
```

---

## 7. Why File I/O Matters for DevOps

✅ **Log Analysis:** Reading and analyzing application/system logs  
✅ **Configuration Management:** Creating and modifying config files  
✅ **Data Processing:** Extracting and transforming text data  
✅ **Automation:** Writing output from scripts to files for auditing  
✅ **Troubleshooting:** Quick access to recent events and errors  
✅ **Backup & Recovery:** Understanding file operations for data safety  

---

## 8. Best Practices

| Practice | Benefit |
|----------|---------|
| Use `>>` by default, only use `>` when you intend to overwrite | Prevents accidental data loss |
| Always verify file content after writing | Ensures data integrity |
| Use `head` and `tail` for large files | Prevents terminal overflow |
| Combine commands with pipes for powerful operations | Enables complex data transformations |
| Use `tee` for logging script outputs | Creates audit trails |

---

## 9. Advanced Commands for Next Practice

```bash
# View last N lines of file
tail -n 10 file.txt

# Search for specific text
grep "search_term" file.txt

# Count specific occurrences
grep -c "word" file.txt

# Combine with piping
cat file.txt | grep "error" | wc -l
```

---

## 10. Resources for Further Learning

- `man touch` - Create files
- `man echo` - Display and write text
- `man cat` - Read and concatenate files
- `man head` / `man tail` - Display file portions
- `man wc` - Count lines, words, characters
- `man tee` - Read from stdin, write to stdout and files
- `man redirections` - Understanding shell I/O redirection

---

**Next Steps:**  
- Practice combining multiple commands with pipes
- Write a script that logs its operations to a file
- Experiment with large files using `head` and `tail` for efficient viewing
- Create config files using `echo` and redirection
