# Day 16 - Shell Scripting Basics

## Task 1 - Hello Script

### Code

```bash
#!/bin/bash

echo "Hello Dosto, Let's start shell scripting!"
```

### Output

```text
Hello Dosto, Let's start shell scripting!
```

### Learning

* Learned how to create executable scripts
* Understood the purpose of the shebang line
* Used chmod +x to execute scripts

---

## Task 2 - Variables

### Code

```bash
#!/bin/bash

NAME="Shubham"
ROLE="DevOps Engineer"

echo "Hello, My name is $NAME and I work as a $ROLE"
```

### Output

```text
Hello, My name is Shubham and I work as a DevOps Engineer
```

### Learning

* Variables are assigned without spaces around =
* Variables are referenced using $
* Double quotes expand variables

---

## Task 3 - User Input

### Code

```bash
#!/bin/bash

echo "Enter your name:"
read NAME

echo "Enter your favourite tool:"
read TOOL

echo "Hello $NAME, I see your favourite tool is $TOOL"
```

### Output

```text
Enter your name:
Shubham

Enter your favourite tool:
Docker

Hello Shubham, I see your favourite tool is Docker
```

---

## Task 4A - Number Check

### Code

```bash
#!/bin/bash

echo "Enter your Number:"
read NUM

if [ "$NUM" -gt 0 ]
then
    echo "Number is Positive"
elif [ "$NUM" -lt 0 ]
then
    echo "Number is Negative"
else
    echo "Number is Zero"
fi
```

### Output

```text
100 -> Number is Positive
-100 -> Number is Negative
0 -> Number is Zero
```

---

## Task 4B - File Exists Check

### Code

```bash
#!/bin/bash

echo "File name? Please enter:"
read FILE

if [ -f "$FILE" ]
then
    echo "File exists"
else
    echo "File not found"
fi
```

### Output

```text
hello.sh -> File exists
Shubham.sh -> File not found
```

---

## Task 5 - Service Check

### Code

```bash
#!/bin/bash

echo "Service name please:"
read SER

echo "Check status? (yes/no)"
read CHOICE

if [ "$CHOICE" = "yes" ]
then

    if systemctl is-active --quiet "$SER"
    then
        echo "$SER is Active"
    else
        echo "$SER is NOT Active"
    fi

else
    echo "Skipped"
fi
```

### Output

```text
nginx is Active
```

---

## Bonus - Age Check

### Code

```bash
#!/bin/bash

echo "Enter your age please:"
read AGE

if [ "$AGE" -ge 18 ]
then
    echo "You're an adult now"
else
    echo "Still a minor"
fi
```

### Output

```text
16 -> Still a minor
18 -> You're an adult now
100 -> You're an adult now
```

---

## Bonus - Disk Usage Check

### Code

```bash
#!/bin/bash

USAGE=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')

echo "Current Usage: $USAGE%"

if [ "$USAGE" -ge 90 ]
then
    echo "CRITICAL"
elif [ "$USAGE" -ge 80 ]
then
    echo "WARNING"
else
    echo "Everything is fine"
fi
```

### Learning

* Used command substitution
* Parsed Linux command output with AWK
* Built a simple monitoring-style script

---

## What I Learned

1. Shell scripts use shebang to define the interpreter.
2. Variables, user input, and conditions form the foundation of automation.
3. AWK can be combined with shell scripts to build monitoring and operational checks.
