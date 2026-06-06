# Linux Practice - Fundamentals

Date: YYYY-MM-DD

---

## 1. Process Checks

### Command 1: List running processes

```bash
ps aux | head
```

Output:

```text
<PASTE YOUR OUTPUT HERE>
```

Observation:
- Displays currently running processes.
- Shows PID, CPU usage, memory usage, and command.

---

### Command 2: Search for a process

```bash
pgrep systemd
```

Output:

```text
<PASTE YOUR OUTPUT HERE>
```

Observation:
- Returns PID(s) matching the process name.

---

## 2. Service Checks

Selected Service: sshd (or cron/docker/nginx depending on your system)

### Command 3: Check service status

```bash
systemctl status sshd
```

Output:

```text
<PASTE YOUR OUTPUT HERE>
```

Observation:
- Confirms whether the service is active, inactive, or failed.

---

### Command 4: List active services

```bash
systemctl list-units --type=service --state=running
```

Output:

```text
<PASTE YOUR OUTPUT HERE>
```

Observation:
- Displays currently running services managed by systemd.

---

## 3. Log Checks

### Command 5: View service logs

```bash
journalctl -u sshd -n 20
```

Output:

```text
<PASTE YOUR OUTPUT HERE>
```

Observation:
- Shows recent log entries for the selected service.

---

### Command 6: View recent system logs

```bash
tail -n 50 /var/log/syslog
```

Output:

```text
<PASTE YOUR OUTPUT HERE>
```

Observation:
- Displays the latest log messages.
- Useful for troubleshooting recent issues.

---

## 4. Mini Troubleshooting Exercise

### Problem

Verify that the SSH service is running.

### Step 1

Check service status:

```bash
systemctl status sshd
```

Result:

```text
<PASTE OUTPUT>
```

### Step 2

Review recent logs:

```bash
journalctl -u sshd -n 20
```

Result:

```text
<PASTE OUTPUT>
```

### Step 3

Verify process exists:

```bash
pgrep sshd
```

Result:

```text
<PASTE OUTPUT>
```

### Conclusion

- SSH service status: Running / Not Running
- Logs reviewed successfully.
- Process verified using pgrep.
