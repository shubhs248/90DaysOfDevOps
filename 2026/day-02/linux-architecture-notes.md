# Linux Architecture & Process Management

## Core Components of Linux

### 1. Kernel
- Heart of the OS; manages hardware (CPU, memory, disk, network)
- Handles process scheduling, memory management, I/O operations
- Runs in privileged mode (kernel space)

### 2. User Space
- Applications, libraries, shell (bash, zsh) run here
- Cannot directly access hardware; must request kernel via system calls
- Safer - a crash here doesn't crash the system

### 3. Init System (systemd)
- First process started by kernel (PID 1)
- Starts all other services and daemons during boot
- Modern systems use **systemd** (replaces older init scripts)
- Manages service dependencies, logging, and resource limits

---

## Process Creation & Management

### How Processes Are Created
1. **Fork** – Parent process creates a copy of itself
2. **Exec** – New process replaces the copy with new code
3. Result: New process runs independently with unique PID (Process ID)

### Process States
| State | Meaning |
|-------|---------|
| **Running** | Currently executing on CPU |
| **Sleeping** | Waiting for I/O or event (can be woken) |
| **Zombie** | Process exited but parent hasn't collected its status; needs cleanup |
| **Stopped** | Paused (suspended by SIGSTOP signal) |
| **Defunct** | Dead process still in process table |

**Key insight:** Zombie processes indicate a parent process isn't properly cleaning up children.

---

## What systemd Does (& Why It Matters)

### Main Responsibilities
- **Service Management** – Start, stop, restart services; handle dependencies
- **Logging** – Centralized journal (`journalctl`) instead of scattered log files
- **Resource Control** – Set CPU/memory limits per service (cgroups)
- **Socket Activation** – Start services only when needed (efficiency)
- **Automatic Restarts** – Keeps failed services alive

### Why This Matters for DevOps
- No more hunting through `/var/log/` files – use `journalctl`
- Services restart automatically → fewer manual interventions
- Can see exactly why a service failed and when
- Predictable behavior across environments

---

## 5 Daily DevOps Commands

```bash
# 1. View running processes with details
ps aux | grep <service-name>

# 2. Real-time process monitoring (CPU, memory, PID)
top -b -n 1 | head -20

# 3. Check service status and recent logs
systemctl status <service-name>

# 4. View service logs (last 50 lines, follow mode)
journalctl -u <service-name> -n 50 -f

# 5. List all running services and their state
systemctl list-units --type=service --state=running
```

---

## Quick Debugging Checklist

**Service won't start?**
- `systemctl status <service>` → Check error message
- `journalctl -u <service> -n 100` → Look for root cause
- `systemctl restart <service>` → Try restart

**High CPU/Memory?**
- `top -o %CPU` → Find culprit process
- `ps aux | grep <pid>` → Get details
- `kill -9 <pid>` → Force terminate if needed

**Zombie processes?**
- `ps aux | grep defunct` → Find them
- Kill parent process (it's not cleaning up children)

---

## Key Takeaways
✓ Kernel manages hardware; user space runs apps  
✓ systemd is process manager + logging hub + service orchestrator  
✓ Process states tell you what's happening (zombie = parent problem)  
✓ Master these 5 commands and you'll solve 80% of Linux issues  
✓ Logs are in journalctl now – learn it inside out
