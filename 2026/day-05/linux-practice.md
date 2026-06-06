# Day 05 – Linux Fundamentals: Process Management

**Date:** June 6, 2026  
**System:** Sandbox Environment

## Overview

This practice session covers fundamental Linux process management concepts:
- Understanding background processes and job control
- Monitoring system resource usage with `top`
- Process inspection with `ps` and `pgrep`
- Managing multiple shell sessions
- CPU and memory analysis
- System load understanding

---

## 1. Echo and Basic Output

### 1.1 Testing Echo Command

**Command:** `echo "Hello Dosto, We are here to practice Linux Commands for day-04"`

**Output:**
```
Hello Dosto, We are here to practice Linux Commands for day-04
```

**Purpose:** Verify shell functionality and basic output before diving into process monitoring

---

## 2. Process Discovery

### 2.1 Searching for Running Processes

**Command:** `ps aux | grep bash`

**Output:**
```
sandbox        1  0.0  0.0   4628  3680 pts/0    Ss+  15:25   0:00 /bin/bash
sandbox       13  0.0  0.0   4628  3856 pts/1    Ss   15:25   0:00 /bin/bash
sandbox       31  0.0  0.0   3472  1516 pts/1    S+   15:28   0:00 grep --color=auto bash
```

**Breakdown of Output:**
| Field | Value | Meaning |
|-------|-------|---------|
| USER | sandbox | User running the process |
| PID | 1, 13, 31 | Process ID (unique identifier) |
| %CPU | 0.0 | CPU percentage usage |
| %MEM | 0.0 | Memory percentage usage |
| VSZ | 4628 | Virtual memory size (KB) |
| RSS | 3680 | Resident set size - actual memory (KB) |
| TTY | pts/0, pts/1 | Terminal identifier |
| STAT | Ss+, S+ | Process state (S=sleeping, s=session leader, +=foreground) |
| START | 15:25 | Process start time |
| TIME | 0:00 | CPU time consumed |
| COMMAND | /bin/bash | The command that started the process |

**Key Findings:**
- Two bash shells running on different pseudo-terminals (pts/0 and pts/1)
- Main bash processes have low CPU/memory (0.0%)
- Each terminal maintains its own session
- The grep command itself appears in output as it searched for bash

---

## 3. System Resource Monitoring

### 3.1 Real-Time System Overview with top

**Command:** `top -b -n 1`

**Output:**
```
top - 15:28:48 up 4 days,  3:49,  0 users,  load average: 0.05, 0.11, 0.04
Tasks:   3 total,   1 running,   2 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.8 us,  0.0 sy,  0.0 ni, 99.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :  32096.1 total,  30018.6 free,    763.2 used,   1314.3 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.  30935.1 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
      1 sandbox   20   0    4628   3680   3224 S   0.0   0.0   0:00.02 bash
     13 sandbox   20   0    4628   3860   3252 S   0.0   0.0   0:00.02 bash
     32 sandbox   20   0    7184   2876   2544 R   0.0   0.0   0:00.00 top
```

**System-Level Metrics:**

| Metric | Value | Interpretation |
|--------|-------|-----------------|
| Uptime | 4 days, 3:49 | System has been running for 4 days |
| Load Average | 0.05, 0.11, 0.04 | CPU load over 1, 5, 15 minutes (very low) |
| Total Tasks | 3 | Three processes running |
| Running | 1 | One process actively running (top itself) |
| Sleeping | 2 | Two processes waiting for events |
| CPU User (us) | 0.8% | Time spent in user-level code |
| CPU System (sy) | 0.0% | Time spent in kernel code |
| CPU Idle (id) | 99.2% | CPU idle time (excellent - very low system load) |
| Total Memory | 32,096 MB | ~32 GB total RAM |
| Free Memory | 30,018 MB | ~30 GB available |
| Used Memory | 763 MB | ~763 MB in use |

**Command Flags:**
- `-b` = batch mode (non-interactive output)
- `-n 1` = run once and exit (instead of continuous refresh)

**Key Insights:**
- System is very lightly loaded (0.05 load average on a multi-core machine)
- CPU is 99.2% idle
- Memory usage is minimal (2.4% of 32GB used)
- Perfect conditions for testing

---

## 4. Process State and Job Control

### 4.1 Viewing Background Jobs

**Command:** `jobs`

**Output:**
```
(no output)
```

**Interpretation:** No background jobs currently running in this shell session

**Process States Reference:**
| State | Symbol | Meaning |
|-------|--------|---------|
| Running | R | Currently executing on CPU |
| Sleeping | S | Waiting for an event |
| Disk Sleep | D | Uninterruptible sleep (I/O wait) |
| Stopped | T | Process stopped (suspended) |
| Zombie | Z | Process terminated but not reaped |

---

### 4.2 Finding Processes by Name

**Command:** `pgrep bash`

**Output:**
```
1
13
```

**Meaning:**
- `pgrep` searches process table for matching names
- Returns PIDs (1 and 13) for all bash processes
- Faster and cleaner than `ps aux | grep bash`
- No trailing grep process in output

**Benefits of pgrep:**
- Simpler syntax than piping with grep
- More efficient for simple process searches
- No false positives from grep itself

---

## 5. Process Management Commands Summary

| Command | Purpose | Example Use Case |
|---------|---------|------------------|
| `ps aux` | List all running processes | Full system overview |
| `ps aux \| grep PATTERN` | Find specific processes | Find all apache processes |
| `pgrep NAME` | Quick process search | Find all bash instances |
| `top` | Real-time monitoring | Monitor system performance |
| `top -b -n 1` | One-time snapshot | Non-interactive monitoring |
| `jobs` | Show background jobs | See suspended processes |
| `bg` | Resume suspended job in background | Continue background work |
| `fg` | Bring background job to foreground | Resume interactive process |

---

## 6. Understanding Load Average

The **load average** shows system utilization:

```
Load Average: 0.05, 0.11, 0.04
                ↓      ↓      ↓
              1 min   5 min  15 min
```

**Interpretation Guide:**
- **< 1.0** = System is idle (processes complete quickly)
- **= 1.0** = System is saturated (on single-core)
- **> 1.0** = System is overloaded (queue building up)

**Example (4-core system):**
- Load 1.0 = 25% CPU busy
- Load 4.0 = 100% CPU busy
- Load 8.0 = Overloaded (150% of capacity)

In this case: **0.05 load** = System is extremely idle

---

## 7. Memory and CPU Analysis

**From the top output:**

```
Memory:
- Total:   32,096 MB (~32 GB)
- Free:    30,018 MB (~93.5% available)
- Used:       763 MB (~2.4%)
- Cache:    1,314 MB

CPU: 99.2% Idle (Excellent!)
```

**Performance Assessment:**
✅ Plenty of free memory for applications  
✅ Very low CPU utilization  
✅ System is ready for heavy workloads  
✅ No bottlenecks detected  

---

## 8. Why Process Management Matters for DevOps

✅ **Performance Monitoring:** Identify resource hogs and bottlenecks  
✅ **Troubleshooting:** Find and stop runaway processes  
✅ **Capacity Planning:** Understand system utilization patterns  
✅ **Automation:** Monitor application health and restart services  
✅ **Logging:** Track process lifecycle for audit trails  
✅ **Optimization:** Tune application performance based on metrics  

---

## 9. Advanced Process Management Commands

```bash
# Find process using specific port
lsof -i :8080

# Monitor process tree
pstree -p

# Show real-time CPU/memory usage by process
watch -n 1 'ps aux --sort=-%cpu | head -10'

# Kill unresponsive process
kill -9 PID

# Limit CPU usage for a process
nice -n 19 ./heavy_process.sh

# Monitor processes using most memory
ps aux --sort=-%mem | head -10
```

---

## 10. Best Practices

| Practice | Benefit |
|----------|---------|
| Check `top` when system feels slow | Quick diagnosis of bottlenecks |
| Use `pgrep` instead of `ps \| grep` | Cleaner and more reliable |
| Monitor load average trends | Early warning system |
| Keep memory usage below 80% | Prevents swap thrashing |
| Regularly review process trees | Understand application behavior |

---

## 11. Resources for Further Learning

- `man ps` - Process status command
- `man top` - System resource monitor
- `man pgrep` - Process grep tool
- `man jobs` - Job control status
- `man kill` - Send signals to processes
- `man watch` - Monitor command output

---

**Next Steps:**  
- Practice suspending and resuming background jobs
- Monitor a running application with top
- Analyze memory usage by different processes
- Create a script to monitor CPU-intensive tasks
