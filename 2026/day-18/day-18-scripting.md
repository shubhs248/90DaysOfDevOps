# Day 18 – Shell Scripting: Functions, Strict Mode & Reusable Scripts

## Overview

Today I moved from writing simple scripts to designing reusable and safer scripts.

Topics covered:

* Functions
* Function Arguments
* Local Variables
* Strict Mode (`set -euo pipefail`)
* Building a Real System Information Reporter

---

## Task 1 – Basic Functions

### functions.sh

```bash
#!/bin/bash

greet() {
    echo "Hello, $1!"
}

add() {
    echo $(($1 + $2))
}

greet "Shubham"
add 10 20
```

### Output

```text
Hello, Shubham!
30
```

---

## Task 2 – Disk & Memory Checker

### disk_usage.sh

```bash
#!/bin/bash

check_disk() {
    echo "===== DISK ====="
    df -h
}

check_memory() {
    echo "===== MEMORY ====="
    free -h
}

check_disk
check_memory
```

### Learned

* Functions help organize scripts.
* Same function can be reused multiple times.
* Easier to maintain than repeating commands.

---

## Task 3 – Strict Mode

### strict_demo.sh

```bash
#!/bin/bash

set -euo pipefail

cat abc.txt | grep test
```

### Observations

#### set -e

Stops script immediately when a command fails.

#### set -u

Throws an error if an undefined variable is used.

#### set -o pipefail

Fails the entire pipeline if any command inside it fails.

---

## Task 4 – Local Variables

### local_demo.sh

```bash
#!/bin/bash

demo() {
    local NAME="Shubham"
    echo "Inside Function: $NAME"
}

demo

echo "Outside Function: $NAME"
```

### Output

```text
Inside Function: Shubham
Outside Function:
```

### Key Learning

Using `local` prevents variables from leaking outside the function.

---

## Task 5 – System Information Reporter

### system_info.sh

```bash
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
    echo "TOP CPU PROCESS"
    echo "================="

    ps aux --sort=-%cpu | head
}

main() {
    system_info
    uptime_info
    disk_info
    memory_info
    cpu_info
}

main
```

---

## Key Learnings

### 1. Functions Make Scripts Reusable

Instead of repeating commands, functions let us organize and reuse code.

### 2. Strict Mode Makes Scripts Safer

Using:

```bash
set -euo pipefail
```

helps catch hidden errors before they become production issues.

### 3. Local Variables Prevent Side Effects

Variables should stay inside functions unless intentionally shared.

---

## DevOps Takeaway

Day 18 felt like the shift from writing scripts to designing scripts.

Functions, strict mode, and reusable patterns are the building blocks of production-grade automation.
