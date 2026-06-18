# Shell Scripting Cheat Sheet

> My personal quick-reference, built from Days 16–20 of #90DaysOfDevOps.
> Every example here is runnable. When you see **Try it**, open a terminal and run it — muscle memory beats reading.

---

## Quick Reference Table

| Topic | Key Syntax | Example |
|-------|-----------|---------|
| Shebang | `#!/bin/bash` | First line of every script |
| Variable | `VAR="value"` | `NAME="DevOps"` |
| Use variable | `"$VAR"` | `echo "Hi $NAME"` |
| Read input | `read VAR` | `read -p "Name: " NAME` |
| Argument | `$1`, `$2`, `$#`, `$@` | `./script.sh arg1 arg2` |
| Exit code | `$?` | `0` = success, non-zero = failure |
| If | `if [ condition ]; then` | `if [ -f file ]; then` |
| String compare | `=`, `!=`, `-z`, `-n` | `[ "$a" = "$b" ]` |
| Number compare | `-eq -ne -lt -gt -le -ge` | `[ "$n" -gt 0 ]` |
| File test | `-f -d -e -r -w -x -s` | `[ -d /tmp ]` |
| For loop | `for i in list; do` | `for i in 1 2 3; do` |
| While loop | `while [ cond ]; do` | `while read line; do` |
| Function | `name() { ... }` | `greet() { echo "Hi"; }` |
| Grep | `grep pattern file` | `grep -i "error" log.txt` |
| Awk | `awk '{print $1}' file` | `awk -F: '{print $1}' /etc/passwd` |
| Sed | `sed 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` |
| Strict mode | `set -euo pipefail` | Top of every serious script |

---

## Task 1 — Basics

### 1. Shebang — `#!/bin/bash`
The very first line. It tells the OS *which interpreter* should run the file. Without it, the script may run under the wrong shell and behave unexpectedly.

```bash
#!/bin/bash
echo "Hello, let's start shell scripting!"
```

**Try it:** save the two lines above as `hello.sh`, then run it (see next item).

### 2. Running a script
Three common ways. Use `chmod +x` once to make a file executable, then `./` to run it. Or skip that and call `bash` directly.

```bash
chmod +x hello.sh    # make it executable (one-time)
./hello.sh           # run via the shebang
bash hello.sh        # run explicitly, no chmod needed
```

### 3. Comments
Anything after `#` is ignored. Use them to explain *why*, not *what*.

```bash
# This is a full-line comment
echo "Deploying"   # this is an inline comment
```

### 4. Variables — declaring, using, quoting
**No spaces around `=`.** Reference with `$`. Quoting changes behaviour:
- `"$VAR"` → expands the value (use this 99% of the time, it survives spaces)
- `'$VAR'` → literal, prints `$VAR` as-is, no expansion

```bash
NAME="Shubham"
ROLE="DevOps Engineer"
echo "Hello, I am $NAME and I work as a $ROLE"   # Hello, I am Shubham and I work as a DevOps Engineer
echo '$NAME'                                     # prints: $NAME
```

> Gotcha I hit early: `NAME = "Shubham"` (with spaces) fails. It must be `NAME="Shubham"`.

### 5. Reading user input — `read`
Pauses and stores what the user types into a variable.

```bash
echo "Enter your name:"
read NAME
read -p "Favourite tool: " TOOL    # -p prints the prompt on the same line
echo "Hello $NAME, you like $TOOL"
```

### 6. Command-line arguments
Values passed to the script when you run it. This is what makes scripts reusable.

| Variable | Meaning |
|----------|---------|
| `$0` | Script name |
| `$1`, `$2`, ... | First, second argument |
| `$#` | Number of arguments |
| `$@` | All arguments (as a list) |
| `$?` | Exit code of the **last** command |

```bash
#!/bin/bash
echo "Script Name: $0"
echo "Total Arguments: $#"
echo "All Arguments: $@"
echo "First Argument: $1"
```

**Try it:** `./args_demo.sh docker terraform k8s` → `Total Arguments: 3`.

---

## Task 2 — Operators and Conditionals

### 1. String comparisons
```bash
[ "$a" = "$b" ]    # equal
[ "$a" != "$b" ]   # not equal
[ -z "$a" ]        # true if string is EMPTY (zero length)
[ -n "$a" ]        # true if string is NOT empty
```

### 2. Integer comparisons
Use these for numbers — **not** `>` or `<` (those mean redirection inside `[ ]`).

```bash
[ "$n" -eq 5 ]   # equal
[ "$n" -ne 5 ]   # not equal
[ "$n" -lt 5 ]   # less than
[ "$n" -gt 5 ]   # greater than
[ "$n" -le 5 ]   # less than or equal
[ "$n" -ge 5 ]   # greater than or equal
```

### 3. File test operators
```bash
[ -f "$f" ]   # is a regular file
[ -d "$f" ]   # is a directory
[ -e "$f" ]   # exists (file OR directory)
[ -r "$f" ]   # readable
[ -w "$f" ]   # writable
[ -x "$f" ]   # executable
[ -s "$f" ]   # exists AND is not empty
```

### 4. `if` / `elif` / `else`
Leave spaces inside the brackets: `[ ... ]`. End the block with `fi`.

```bash
read -p "Enter a number: " NUM
if [ "$NUM" -gt 0 ]; then
    echo "Positive"
elif [ "$NUM" -lt 0 ]; then
    echo "Negative"
else
    echo "Zero"
fi
```

### 5. Logical operators
```bash
# AND: run second only if first succeeds
mkdir /tmp/app && cd /tmp/app

# OR: run second only if first fails (great fallback)
cd /tmp/app || echo "Could not enter directory"

# NOT
if [ ! -d "$DIR" ]; then echo "Directory missing"; fi

# Combine inside a test
if [ "$NUM" -ge 18 ] && [ "$NUM" -le 60 ]; then echo "Working age"; fi
```

### 6. Case statements
Cleaner than a long `if/elif` chain when matching one value against many options.

```bash
read -p "Action (start/stop/restart): " ACTION
case "$ACTION" in
    start)   echo "Starting service" ;;
    stop)    echo "Stopping service" ;;
    restart) echo "Restarting service" ;;
    *)       echo "Unknown action" ;;   # * is the default/catch-all
esac
```

---

## Task 3 — Loops

### 1. `for` loop — list-based and C-style
```bash
# List-based
for fruit in Apple Mango Banana; do
    echo "$fruit"
done

# Range
for num in {1..5}; do
    echo "$num"
done

# C-style
for ((i=1; i<=5; i++)); do
    echo "Count $i"
done
```

### 2. `while` loop — runs while condition is true
```bash
read -p "Enter number: " NUM
while [ "$NUM" -ge 0 ]; do
    echo "$NUM"
    NUM=$((NUM - 1))    # arithmetic with $(( ))
done
echo "Done!"
```

### 3. `until` loop — runs until condition becomes true (opposite of while)
```bash
COUNT=1
until [ "$COUNT" -gt 5 ]; do
    echo "Attempt $COUNT"
    COUNT=$((COUNT + 1))
done
```

### 4. Loop control — `break` and `continue`
```bash
for i in {1..10}; do
    [ "$i" -eq 8 ] && break       # stop the loop entirely at 8
    [ "$i" -eq 3 ] && continue    # skip 3, jump to next iteration
    echo "$i"
done
```

### 5. Looping over files
The `*.log` expands to matching filenames. Always quote `"$file"` to survive spaces.

```bash
for file in *.log; do
    echo "Processing $file"
    wc -l "$file"
done
```

### 6. Looping over command output — `while read`
The standard pattern for reading a file (or command output) line by line.

```bash
while read -r line; do
    echo "Line: $line"
done < /etc/hosts        # feed a file in

# Or from a pipe:
grep "ERROR" app.log | while read -r line; do
    echo "Found: $line"
done
```

---

## Task 4 — Functions

### 1 & 2. Defining and calling
Define before you call. Calling is just the function name — no parentheses.

```bash
greet() {
    echo "Hello, World!"
}
greet    # call it
```

### 3. Passing arguments
Inside a function, `$1`, `$2` are the function's **own** arguments (not the script's).

```bash
greet() {
    echo "Hello, $1!"
}
add() {
    echo $(($1 + $2))
}
greet "Shubham"   # Hello, Shubham!
add 10 20         # 30
```

### 4. Return values — `return` vs `echo`
- `echo` → send back **data** (a string/number), capture with `$( )`.
- `return` → send back an **exit status** (0–255 only), check with `$?`. Use it for success/failure, not data.

```bash
# echo for data
get_hostname() {
    echo "$(hostname)"
}
HOST=$(get_hostname)        # capture the output
echo "Running on $HOST"

# return for status
is_even() {
    if [ $(($1 % 2)) -eq 0 ]; then return 0; else return 1; fi
}
if is_even 4; then echo "Even"; fi    # uses the return code
```

### 5. Local variables — `local`
By default variables are global. `local` keeps them inside the function so they don't leak and clobber other variables.

```bash
demo() {
    local NAME="Shubham"
    echo "Inside: $NAME"
}
demo
echo "Outside: $NAME"    # prints "Outside: " — NAME never escaped the function
```

> Pattern I use everywhere now: a `main()` function at the bottom that calls all the others, then a single `main` call. Keeps scripts organized (see my Day 19/20 projects).

---

## Task 5 — Text Processing Commands

The bread and butter of log analysis and DevOps glue work.

### 1. `grep` — search for patterns
```bash
grep "error" app.log         # lines containing "error"
grep -i "error" app.log      # -i  case-insensitive
grep -r "TODO" ./src         # -r  recursive through a directory
grep -c "error" app.log      # -c  count matching lines
grep -n "error" app.log      # -n  show line numbers
grep -v "DEBUG" app.log      # -v  invert: lines that DON'T match
grep -E "ERROR|FAILED" app.log   # -E  extended regex (use | for OR)
```
**Real one I used (Day 20):** `grep -Eci "ERROR|FAILED" app.log` → case-insensitive count of all errors.

### 2. `awk` — work with columns/fields
Splits each line into fields (`$1`, `$2`, ...). `$0` is the whole line.

```bash
awk '{print $1}' file              # print first column
awk -F: '{print $1}' /etc/passwd   # -F sets the field separator (here, ":")
awk '$3 > 100 {print $1}' data     # pattern: only rows where col 3 > 100
awk 'BEGIN{print "Start"} {print} END{print "Total:", NR}' file   # NR = line count
```
**Real one I used (Day 16):** parse disk usage → `df -h / | awk 'NR==2 {gsub("%","",$5); print $5}'`.

### 3. `sed` — stream editor (find/replace, delete)
```bash
sed 's/old/new/' file          # replace FIRST match per line
sed 's/old/new/g' file         # g = replace ALL matches per line
sed -i 's/foo/bar/g' config    # -i = edit the file IN PLACE (careful!)
sed '3d' file                  # delete line 3
sed '/DEBUG/d' app.log         # delete every line containing DEBUG
```
> Tip: test `sed` without `-i` first to preview, then add `-i` once you're sure.

### 4. `cut` — extract columns by delimiter
```bash
cut -d: -f1 /etc/passwd     # -d delimiter, -f field → usernames
cut -d, -f2,3 data.csv      # fields 2 and 3 from a CSV
cut -c1-5 file              # characters 1 through 5
```

### 5. `sort`
```bash
sort file              # alphabetical
sort -n file           # -n numeric
sort -r file           # -r reverse
sort -u file           # -u sorted + unique
sort -k2 file          # sort by the 2nd column
```

### 6. `uniq` — remove/count *adjacent* duplicates (sort first!)
```bash
sort file | uniq          # unique lines
sort file | uniq -c       # -c prefix each line with its count
sort file | uniq -c | sort -rn   # the classic "top N" pattern
```

### 7. `tr` — translate or delete characters
```bash
echo "hello" | tr 'a-z' 'A-Z'    # HELLO
echo "a,b,c" | tr ',' '\n'       # split on commas into lines
echo "h e l l o" | tr -d ' '     # -d delete spaces → hello
```

### 8. `wc` — count lines/words/characters
```bash
wc -l file        # -l line count
wc -w file        # -w word count
wc -c file        # -c byte count
wc -l < file      # use < to get JUST the number (no filename)
```

### 9. `head` / `tail`
```bash
head -5 file      # first 5 lines
tail -5 file      # last 5 lines
tail -f app.log   # -f follow: stream new lines live (Ctrl-C to stop)
```

**The combined pipeline I built on Day 20 (top 5 recurring errors):**
```bash
grep -Ei "ERROR|FAILED" app.log \
  | awk '{$1=$2=$3=""; print}' \
  | sort | uniq -c | sort -rn | head -5
```
Read it left to right: *find errors → strip the timestamp columns → sort → count duplicates → sort by count descending → take top 5.*

---

## Task 6 — Useful Patterns and One-Liners

```bash
# 1. Find and delete files older than 30 days
find /var/log -name "*.log" -mtime +30 -delete

# 2. Count total lines across all .log files
wc -l *.log

# 3. Replace a string across multiple files (in place)
sed -i 's/old_url/new_url/g' *.conf

# 4. Check if a service is running
systemctl is-active --quiet nginx && echo "running" || echo "stopped"

# 5. Disk usage alert (the heart of a monitoring script)
USAGE=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')
[ "$USAGE" -ge 80 ] && echo "WARNING: disk at ${USAGE}%"

# 6. Tail a log and filter errors in real time
tail -f app.log | grep --line-buffered -i "error"

# 7. Find the 5 largest files in a directory tree
find . -type f -exec du -h {} + | sort -rh | head -5

# 8. Compress logs older than 7 days (from my Day 19 log_rotate.sh)
find /var/log -name "*.log" -mtime +7 -exec gzip {} \;

# 9. Timestamped backup archive (from my Day 19 backup.sh)
tar -czf "backup-$(date +%Y-%m-%d-%H-%M-%S).tar.gz" /path/to/source
```

---

## Task 7 — Error Handling and Debugging

### 1. Exit codes — `$?`, `exit 0`, `exit 1`
Every command returns a code: `0` = success, anything else = failure. Your script should too.

```bash
ls /tmp
echo "$?"        # 0 if the ls worked

exit 0           # signal success
exit 1           # signal failure (use this after printing a usage/error message)
```
Common guard at the top of a script:
```bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi
```

### 2. `set -e` — exit immediately on any error
Stops the script the moment a command fails, instead of blindly continuing.

### 3. `set -u` — treat unset variables as errors
Catches typos like `$FILENAEM` instead of silently using an empty string.

### 4. `set -o pipefail` — catch failures inside pipes
Normally a pipeline's exit code is just the *last* command's. `pipefail` makes it fail if *any* stage fails.

**The combined "strict mode" I now put at the top of every real script:**
```bash
#!/bin/bash
set -euo pipefail        # -e exit on error, -u unset = error, -o pipefail catch pipe failures
```

### 5. `set -x` — debug/trace mode
Prints each command (with expanded variables) before running it. Priceless for "why isn't this working?".

```bash
set -x
NAME="Shubham"
echo "Hello $NAME"
set +x          # turn tracing back off
```
**Try it:** add `set -x` to any script and watch every step print.

### 6. `trap` — run cleanup on exit
Runs a command when the script exits (or is interrupted) — perfect for removing temp files.

```bash
cleanup() {
    echo "Cleaning up temp files..."
    rm -f /tmp/myapp.*
}
trap cleanup EXIT        # run cleanup whenever the script exits, success or fail
```

---

## My Reusable Script Template

This is the skeleton I now start every script from — it combines everything above (strict mode, argument check, functions, a `main`, and cleanup).

```bash
#!/bin/bash
set -euo pipefail

# --- argument check ---
if [ $# -eq 0 ]; then
    echo "Usage: $0 <argument>"
    exit 1
fi

INPUT="$1"

# --- cleanup on exit ---
cleanup() {
    echo "Cleaning up..."
}
trap cleanup EXIT

# --- functions ---
validate() {
    if [ ! -e "$INPUT" ]; then
        echo "Error: '$INPUT' does not exist"
        exit 1
    fi
}

process() {
    echo "Processing $INPUT ..."
    # real work here
}

# --- entry point ---
main() {
    validate
    process
    echo "Done."
}

main
```

---

## Mistakes I Made (and how I fixed them)

- **Spaces around `=`** → `VAR="x"`, never `VAR = "x"`.
- **Missing spaces inside `[ ]`** → it must be `[ "$a" = "$b" ]`, not `["$a"="$b"]`.
- **Using `>` for numbers** → use `-gt`; `>` means redirect a file.
- **Unquoted variables** → always `"$VAR"`, especially paths that may contain spaces.
- **Forgetting `uniq` needs sorted input** → `sort | uniq -c`, never `uniq` alone.

---

*Built during #90DaysOfDevOps (Days 16–20). #DevOpsKaJosh #TrainWithShubham*
