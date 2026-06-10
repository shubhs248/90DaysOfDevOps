# Day 12 – Breather & Revision (Days 01–11)

> One-day consolidation of fundamentals from Days 01–11. Notes below are based on today's hands-on re-runs in `practice.txt`.

---

## Days 01–11 Quick Recap

| Day | Topic | Key takeaway |
|-----|-------|--------------|
| 01 | DevOps mindset & learning plan | DevOps is culture + automation + collaboration; keep revisiting the Day 01 plan as skills grow |
| 02 | Cloud basics | EC2, SSH, and getting a Linux box ready for practice |
| 03 | Linux commands | Navigation, files, search, and the command cheat sheet to reach for in incidents |
| 04 | Processes & services | `ps`, `systemctl`, and understanding what is running on the box |
| 05 | CPU, memory & logs | Troubleshooting under load; reading system and service logs |
| 06 | File I/O | `echo`, `cat`, `>>`, redirecting and appending text |
| 07 | Filesystem hierarchy | Where configs, logs, and binaries live (`/etc`, `/var/log`, `/home`, etc.) |
| 08 | Nginx & web deployment | Install, enable, and verify a web service on port 80 |
| 09 | Users & groups | `useradd`, `groupadd`, `id`, `/etc/passwd`, `/etc/group` |
| 10 | File permissions | `chmod` symbolic and numeric modes; read/write/execute for u/g/o |
| 11 | File ownership | `chown`, `chgrp`, `find -user`, recursive ownership with `-R` |

---

## Section Checkpoints

### Mindset & plan (Day 01)

- Goals still on track: build strong Linux + cloud fundamentals before moving deeper into automation and containers.
- Small tweak: spend more deliberate time on **permission + ownership combos** (Days 10–11)—they showed up again today when running a script as another user.
- Keep the daily hands-on habit; revision day confirmed that re-running commands beats re-reading notes alone.

### Processes & services (Days 04/05)

**Commands re-run today:**

```bash
ps aux --sort=-%cpu | head -10
sudo systemctl status ssh
sudo systemctl status nginx    # not installed at first; installed later
journalctl -u ssh -n 50
journalctl -u nginx -n 50
```

**Observations:**

- `ps aux --sort=-%cpu | head -10` failed; **`head -10`** (with the dash) is required—without it, `head` treats `10` as a filename.
- `ssh.service` was **active (running)**; logs showed successful publickey logins and normal start/stop across reboots.
- `nginx` was not installed initially (`Unit nginx.service could not be found`); after `apt install nginx`, `journalctl -u nginx` showed start/stop events.
- Top CPU consumers after re-check: `systemd` (PID 1), `fwupd`, `sshd-session`—system looked healthy.

### File skills (Days 06–11)

**Commands re-run today:**

```bash
echo "Day 12 revision" >> revision.txt
ls -l revision.txt
sudo chown tokyo revision.txt
mkdir revision && mv revision.txt revision/
echo "Practice chal rahi hai Dosto" >> revision/revision.txt
sudo chmod u+x revision/revision.txt
sudo chmod 755 revision/revision.txt
sudo chmod 600 revision/revision.txt
find . -user tokyo
find . -user professor
tree revision
```

**Observations:**

- Appending with `>>` preserved existing content; `ls -l` confirmed owner change to `tokyo:ubuntu`.
- `find -user` quickly surfaced Day 11 leftovers (`team-notes.txt`, `bank-heist/`, `heist-project/`).
- `chmod 755` → `-rwxr-xr-x`; `chmod 600` → `-rw-------` (owner read/write only)—numeric modes clicked faster on second pass.
- Mistake caught: `cat /revision/revision.txt` used absolute path incorrectly; file lived at `~/revision/revision.txt`.

### Cheat sheet refresh (Day 03) — 5 commands for an incident

| Command | Why reach for it first |
|---------|------------------------|
| `ps aux --sort=-%cpu \| head -20` | See what is consuming CPU right now |
| `sudo systemctl status <service>` | Is the service loaded, active, and failing? |
| `journalctl -u <service> -n 50` | Recent service logs without hunting log files |
| `sudo ss -tulnp \| grep <port>` | Confirm what process is listening on a port |
| `ls -l` | Check permissions/ownership when access fails |

### User/group sanity (Days 09/11)

**Scenario re-run:** changed ownership of `revision.txt` to user `tokyo` and verified with `id` and `find`.

```bash
sudo chown tokyo revision.txt
id tokyo
# uid=1001(tokyo) gid=1001(tokyo) groups=1001(tokyo),1000(ubuntu),1002(devs)
find . -user tokyo
```

**Bonus script permission drill:**

```bash
echo '#!/bin/bash' > shebanh.sh          # single quotes avoid bash history ! expansion
echo 'echo "Script successfully executed"' >> shebanh.sh
chmod u+x shebanh.sh
sudo chgrp devs shebanh.sh
sudo chmod g+x shebanh.sh
sudo -u tokyo ./shebanh.sh               # worked after group execute was set
```

**Lesson:** running a file as another user needs **execute on the file** and the right **owner/group + mode**; confusing `chown` with `chmod` (`chown g+x` fails) is an easy slip—use `chmod g+x`.

### Nginx service drill (Day 08 refresh)

```bash
sudo apt update
sudo apt install nginx
systemctl is-enabled nginx    # enabled
sudo ss -tulnp | grep 80      # nginx listening on 0.0.0.0:80 and [::]:80
sudo systemctl disable nginx
sudo systemctl stop nginx
journalctl -u nginx -n 50
```

**Observations:**

- `sudo ss -tulnp` works; `sudo -tulnp` is invalid (typo from Day 08 notes).
- `systemctl disable nginx` needs **`sudo`** on this box—without it, polkit prompted for authentication.
- After stop: journal showed clean deactivation (`Deactivated successfully`).

---

## Mini Self-Check

### 1) Which 3 commands save you the most time right now, and why?

1. **`journalctl -u <service> -n 50`** — pulls recent service logs in one shot instead of searching under `/var/log`.
2. **`systemctl status <service>`** — instant answer on whether a service is running, enabled, and what failed at startup.
3. **`find . -user <name>`** — fast way to locate files by owner after `chown` exercises or access issues.

### 2) How do you check if a service is healthy? List the exact 2–3 commands you'd run first.

```bash
sudo systemctl status <service>
journalctl -u <service> -n 50
sudo ss -tulnp | grep <port-or-process>
```

For nginx specifically: confirm **active (running)**, no errors in journal, and port **80** is listening.

### 3) How do you safely change ownership and permissions without breaking access?

Change **owner first**, verify with `ls -l` and `id`, then adjust permissions in small steps:

```bash
sudo chown tokyo:ubuntu revision.txt
ls -l revision.txt
sudo chmod 644 revision.txt    # safe default for a readable file
```

For shared access within a group:

```bash
sudo chgrp devs shebanh.sh
sudo chmod 750 shebanh.sh      # owner rwx, group rx, others none
```

Always verify as the target user: `sudo -u tokyo cat revision/revision.txt`.

### 4) What will you focus on improving in the next 3 days?

- **Bash scripting basics** — shebang, quoting, and making scripts executable without permission surprises.
- **Service lifecycle** — install → enable → verify → stop/disable → read logs (nginx drill today was a good template).
- **Stronger muscle memory on `chmod` numeric modes** (644, 755, 600) and when to use symbolic vs numeric.

---

## Mistakes & Fixes (worth remembering)

| Mistake | Fix |
|---------|-----|
| `head 10` after pipe | Use `head -10` |
| `ps aux sort=-%cpu` | Use `ps aux --sort=-%cpu` |
| `echo "#!/bin/bash"` | Use single quotes: `echo '#!/bin/bash'` |
| `sudo -tulnp` | Use `sudo ss -tulnp` |
| `chown g+x file` | Use `chmod g+x file` |
| `systemctl disable` without sudo | Use `sudo systemctl disable <service>` |

---

## Key Takeaways

- Revision day worked: re-running Day 04/05 service checks and Day 10/11 permission drills exposed small syntax gaps that are easy to forget.
- **`systemctl` + `journalctl` + `ss`** is a reliable first triage trio for service health.
- Ownership and permissions stack together—changing owner alone does not grant access if modes or parent directory execute bits block the user.
- Installing nginx from scratch and tracing it through enable → listen → disable → stop reinforced Day 08 end-to-end.

---

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
