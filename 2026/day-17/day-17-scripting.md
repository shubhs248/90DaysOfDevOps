# Day 17 – Shell Scripting: Loops, Arguments & Error Handling

## Overview

Today I moved beyond basic shell scripting and started building scripts that can automate repetitive tasks.

Topics covered:

* For Loops
* While Loops
* Command-Line Arguments
* Package Installation Automation
* Error Handling
* Service Status Checks

---

## Task 1 – For Loops

### for_loop.sh

```bash
#!/bin/bash

for fruit in Apple Mango Banana Orange Grapes
do
    echo $fruit
done
```

### Output

```text
Apple
Mango
Banana
Orange
Grapes
```

---

### count.sh

```bash
#!/bin/bash

for num in {1..10}
do
    echo $num
done
```

### Output

```text
1
2
3
4
5
6
7
8
9
10
```

---

## Task 2 – While Loop

### countdown.sh

```bash
#!/bin/bash

echo "Enter Number:"
read NUM

while [ $NUM -ge 0 ]
do
    echo $NUM
    NUM=$((NUM-1))
done

echo "Done!"
```

### Sample Output

```text
5
4
3
2
1
0
Done!
```

---

## Task 3 – Command Line Arguments

### greet.sh

```bash
#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Usage: ./greet.sh <name>"
    exit 1
fi

echo "Hello $1"
```

### Example

```bash
./greet.sh Shubham
```

Output:

```text
Hello Shubham
```

---

### args_demo.sh

```bash
#!/bin/bash

echo "Script Name: $0"
echo "Total Arguments: $#"
echo "All Arguments: $@"
```

### Example

```bash
./args_demo.sh docker terraform k8s
```

Output:

```text
Script Name: ./args_demo.sh
Total Arguments: 3
All Arguments: docker terraform k8s
```

---

## Task 4 – Package Installation Script

### install_packages.sh

```bash
#!/bin/bash

packages="nginx curl wget"

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root only, exiting ..."
    exit 1
fi

for package in $packages
do
    dpkg -s $package > /dev/null 2>&1

    if [ $? -eq 0 ]
    then
        echo "$package already installed"
    else
        echo "Installing $package ..."
        apt install -y $package
    fi
done
```

### Output

```text
nginx already installed
curl already installed
wget already installed
```

---

## Task 5 – Error Handling

### safe_script.sh

```bash
#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"

cd /tmp/devops-test || {
    echo "Cannot enter directory"
    exit 1
}

touch demo.txt

echo "File created successfully"
```

### Output

```text
Directory already exists
File created successfully
```

---

## Bonus Task – Service Status Check

### service_check.sh

```bash
#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Usage: ./service_check.sh <service>"
    exit 1
fi

if systemctl is-active --quiet "$1"
then
    echo "$1 is running"
else
    echo "$1 is stopped"
fi
```

### Example

```bash
./service_check.sh nginx
```

Output:

```text
nginx is running
```

---

## Key Learnings

### 1. Loops automate repetitive work

Instead of repeating commands manually, loops allow scripts to perform the same action across multiple values.

### 2. Arguments make scripts reusable

Using `$1`, `$@`, and `$#` allows one script to work for different inputs.

### 3. Error handling matters

Using `set -e`, `||`, and exit codes helps scripts fail safely and predictably.

---

## DevOps Takeaway

Today's scripting exercises felt like the transition from running commands manually to building repeatable automation.

Small scripts today become deployment, monitoring, and operational automation tomorrow.
