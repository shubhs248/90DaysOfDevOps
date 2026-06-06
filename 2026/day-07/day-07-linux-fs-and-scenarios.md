# Day 07 – Linux Fundamentals: Filesystem & System Management

**Date:** June 6, 2026  
**System:** WSL (Ubuntu on Windows Subsystem Linux)

## Overview

This practice session covers essential Linux system administration tasks:
- Exploring filesystem directories and binary locations
- Understanding symbolic links and PATH resolution
- System service management with `systemctl`
- Process monitoring and performance analysis
- Basic bash scripting and script execution

---

## 1. Filesystem Exploration

### 1.1 Exploring the /bin Directory

**Objective:** Understand binary locations and symbolic links

**Command:** `ls -la /bin/ | head -20`

**Output:**
```
total 119200
drwxr-xr-x   2 root root       28672 Jun  3 16:13 .
drwxr-xr-x  12 root root        4096 Apr 20 18:05 ..
lrwxrwxrwx   1 root root           4 Dec  6 09:38 NF -> col1
lrwxrwxrwx   1 root root           1 Feb 27 18:18 X11 -> .
lrwxrwxrwx   1 root root          28 Mar 30 16:50 [ -> ../lib/cargo/bin/coreutils/[
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-enabled
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-exec
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-features-abi
-rwxr-xr-x   1 root root       25004 Apr  2 02:23 add-apt-repository
lrwxrwxrwx   1 root root          26 Mar 15 01:33 addr2line -> x86_64-linux-gnu-addr2line
-rwxr-xr-x   1 root root        2322 Apr  9 11:58 apport-bug
-rwxr-xr-x   1 root root       13936 Apr 13 11:51 apport-cli
lrwxrwxrwx   1 root root          10 Apr 13 11:51 apport-collect -> apport-bug
-rwxr-xr-x   1 root root        3798 Apr 13 11:51 apport-unpack
-rwxr-xr-x   1 root root      141616 Jan 28 21:08 appstreamcli
lrwxrwxrwx   1 root root           6 Feb  2 20:49 apropos -> whatis
-rwxr-xr-x   1 root root       23072 Apr  7 09:02 apt
lrwxrwxrwx   1 root root          18 Apr  2 02:23 apt-add-repository -> add-apt-repository
-rwxr-xr-x   1 root root      100904 Apr  7 09:02 apt-cache
-rwxr-xr-x   1 root root       27176 Apr  7 09:02 apt-cdrom
```

**Key Findings:**
- Mix of regular executables and symbolic links
- Symbolic links (marked with `lrwxrwxrwx` and `->`) point to other binaries
- Example: `apropos -> whatis` means `apropos` is an alias to `whatis`
- File sizes vary: from 2KB (apport-bug) to 140KB (appstreamcli)

---

### 1.2 Finding Command Locations with `which`

**Objective:** Locate where common commands reside

**Commands & Results:**

```bash
$ which ls
/usr/bin/ls

$ which cat
/usr/bin/cat

$ which systemctl
/usr/bin/systemctl
```

**Observations:**
- Most common utilities are in `/usr/bin/`, NOT `/bin/`
- The shell searches these paths via the `$PATH` environment variable
- `/usr/bin/` contains user utilities; `/bin/` contains essential system binaries
- Understanding this is critical for troubleshooting missing commands

---

## 2. Service Management with systemctl

### 2.1 Listing Active Services

**Command:** `systemctl list-units --type=service`

**Output:** 35 loaded units listed

**Key Services Running:**
- `chrony.service` - NTP client/server for time synchronization
- `cron.service` - Regular background program processing daemon
- `dbus.service` - D-Bus System Message Bus (inter-process communication)
- `systemd-journald.service` - Central logging service
- `systemd-logind.service` - User login/session management
- `rsyslog.service` - System logging service
- `wsl-pro.service` - Bridge to Ubuntu Pro agent on Windows (WSL indicator)

**System Observations:**
- This system is running in **WSL (Windows Subsystem Linux)**
- All essential system services are active
- Mix of startup (active/exited) and runtime services

---

### 2.2 Checking Service Status & Startup

**Command:** `systemctl is-enabled console-setup.service`

**Output:** `enabled`

**Meaning:** This service is configured to start automatically on boot.

---

### 2.3 Viewing Service Logs

**Command:** `journalctl -u console-setup.service -n 20`

**Output:**
```
Jun 06 06:00:19 Shubham-Laptop systemd[1]: Starting console-setup.service - Set console font and keymap...
Jun 06 06:00:19 Shubham-Laptop systemd[1]: Finished console-setup.service - Set console font and keymap.
```

**Checking Recent Activity:**

**Command:** `journalctl -u console-setup.service --since "1 hour ago"`

**Output:** `-- No entries --`

**Interpretation:**
- Service started at 06:00:19 AM
- Currently no activity in the last hour (service completed its task and exited)
- This is expected behavior for one-time setup services

---

## 3. Process Monitoring & Analysis

### 3.1 Understanding ps with CPU Sorting

**Command (Attempted):** `ps aux --sort=-%cpu | head -10`

**Initial Error:**
```
ps =aux --sort=-%cpu| head -10
error: garbage option
```

**Correction:** Remove the `=` sign

**Corrected Command:** `ps aux --sort=-%cpu | head -10`

**Output (Corrected):**
```
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
shubhs2+    1884  0.0  0.0   6392  5776 pts/2    Ss   16:06   0:00 -bash
root        1881  0.0  0.0   3192  1252 ?        S    16:06   0:00 /init
root         104  0.0  0.1  35092 12100 ?        Ss   08:15   0:02 /usr/lib/systemd/systemd-udevd
root        4445  0.0  0.1 1792292 14692 ?       Ssl  17:35   0:00 /usr/libexec/wsl-pro-service
root           1  0.0  0.1  24704 15452 ?        Ss   08:15   0:01 /sbin/init
root          58  0.0  0.2  50372 16792 ?        S<s  08:15   0:00 /usr/lib/systemd/journald
shubhs2+    2435  0.0  0.1  22404 12604 pts/2    Tl   16:19   0:00 vi .git/config
shubhs2+     430  0.0  0.0   8296  6680 pts/0    Ss+  08:15   0:00 -bash
_chrony      238  0.0  0.1  24500 11716 ?        S    08:15   0:00 /usr/sbin/chronyd
```

**Key Learning:**
- The `-` prefix in `--sort=-%cpu` sorts in **descending order** (highest CPU first)
- Without the `-`, sorting is ascending (lowest CPU first)
- All processes showing 0.0% CPU indicates minimal system load

### 3.2 Process Details

**Command:** `ps -fp 1884`

**Output:**
```
UID          PID    PPID  C STIME TTY          TIME CMD
shubhs2+    1884    1881  0 16:06 pts/2    00:00:00 -bash
```

**Breakdown:**
- **PID 1884:** The bash shell process
- **PPID 1881:** Parent process (init wrapper for WSL)
- **STIME 16:06:** Started at 4:06 PM
- **TTY pts/2:** Pseudo-terminal

---

## 4. Hands-On: Creating & Executing a Bash Script

### 4.1 Script Creation Process

**Step 1: Create file**
```bash
$ touch backup.sh
```

**Step 2: Write shebang (script interpreter)**
```bash
$ echo '#!/bin/bash' > backup.sh
```

**⚠️ Important:** Use **single quotes** to avoid bash history expansion issues.
- ❌ Wrong: `echo "#!/bin/bash"` → Error: `-bash: !/bin/bash: event not found`
- ✅ Correct: `echo '#!/bin/bash'` → Works as expected

**Step 3: Add script content**
```bash
$ echo 'echo "BAckup Completed"' >> backup.sh
```

**Step 4: View script**
```bash
$ cat backup.sh
#!/bin/bash
echo "BAckup Completed"
```

**Step 5: Execute script**
```bash
$ ./backup.sh
BAckup Completed
```

**Result:** ✅ Script executed successfully

---

## 5. Common Mistakes & Corrections

| Mistake | Correction | Reason |
|---------|-----------|--------|
| `ps =aux --sort=-%cpu` | `ps aux --sort=-%cpu` | The `=` is not part of ps syntax |
| `ps aux --sort=%cpu` | `ps aux --sort=-%cpu` | Need `-` prefix for descending order (highest first) |
| `echo "#!/bin/bash"` | `echo '#!/bin/bash'` | Double quotes trigger bash history expansion with `!` |
| `touch backup.sh` (then no execute) | `chmod +x backup.sh` or just run it | Script needs execute permissions or explicit bash invocation |

---

## 6. Directory Structure After Practice

```bash
$ ls -la
total 8
drwxrwxrwx 1 root root 4096 Jun  6 17:47 .
drwxrwxrwx 1 root root 4096 Jun  6 15:59 ..
-rwxrwxrwx 1 root root 6273 Jun  6 15:59 README.md
-rwxrwxrwx 1 root root   36 Jun  6 17:49 backup.sh
-rwxrwxrwx 1 root root    0 Jun  6 17:12 day-07-linux-fs-and-scenarios.md
```

---

## 7. Summary of Key Commands

| Command | Purpose | Use Case |
|---------|---------|----------|
| `ls -la /bin/` | List binaries with permissions & details | Explore filesystem structure |
| `which <command>` | Find full path to a command | Verify tool is installed and accessible |
| `systemctl list-units --type=service` | Show all loaded services | System status check |
| `systemctl is-enabled <service>` | Check if service auto-starts | Verify startup configuration |
| `journalctl -u <service> -n 20` | View recent service logs | Troubleshooting |
| `ps aux --sort=-%cpu` | List processes sorted by CPU | Performance monitoring |
| `ps -fp <PID>` | Show detailed info for specific process | Process investigation |

---

## 8. Why This Matters for DevOps

✅ **Service Management:** Managing application services is a daily task  
✅ **Process Monitoring:** CPU/memory analysis helps identify bottlenecks and resource leaks  
✅ **Filesystem Knowledge:** Understanding `/bin`, `/usr/bin`, `/etc` is foundational  
✅ **Scripting:** Automation and infrastructure-as-code depend on bash scripts  
✅ **Log Analysis:** Troubleshooting requires understanding journalctl and log files  
✅ **System Health:** Regular service/process checks catch issues before they escalate  

---

## 9. Resources for Further Learning

- `man ls` - File listing and attributes
- `man ps` - Process status and monitoring
- `man systemctl` - Service and system management
- `man bash` - Bash shell scripting basics
- `man journalctl` - Journal/log querying

---

**Next Steps:**  
- Practice service restart: `sudo systemctl restart <service>`
- Write a more complex backup script with error handling
- Explore `/etc/systemd/system/` to understand service definitions
