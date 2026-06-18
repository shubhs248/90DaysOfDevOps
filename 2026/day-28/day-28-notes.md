# Day 28 – Revision: Everything from Day 1 to Day 27

> No new concepts today. Honest self-assessment, revisiting weak spots, and teaching one thing back.

---

## Task 1 – Self-Assessment Checklist

### Linux
- [x] Navigate the file system, create/move/delete files and directories — **Confident**
- [x] Manage processes — list, kill, background/foreground — **Confident**
- [x] Work with systemd — start/stop/enable/status — **Confident**
- [ ] Read and edit files using vi/vim or nano — **Need to revisit** (vim shortcuts still slow me down)
- [x] Troubleshoot CPU/memory/disk with top, free, df, du — **Confident**
- [x] Explain the file system hierarchy (/, /etc, /var, /home, /tmp) — **Confident**
- [x] Create users and groups, manage passwords — **Confident**
- [x] Set permissions with chmod (numeric + symbolic) — **Confident**
- [x] Change ownership with chown/chgrp — **Confident**
- [ ] Create and manage LVM volumes — **Need to revisit** (PV/VG/LV order trips me up)
- [x] Network checks — ping, curl, netstat, ss, dig, nslookup — **Confident**
- [x] Explain DNS, IP addressing, subnets, common ports — **Confident**

### Shell Scripting
- [x] Variables, arguments, user input — **Confident**
- [x] if/elif/else and case — **Confident**
- [x] for, while, until loops — **Confident**
- [x] Functions with arguments and return values — **Confident**
- [x] grep, awk, sed, sort, uniq — **Confident** (Day 20 log analyzer cemented this)
- [x] Error handling: set -e/-u/-o pipefail, trap — **Confident**
- [ ] Schedule scripts with crontab — **Need to revisit** (cron syntax fields)

### Git & GitHub
- [x] init, stage, commit, history — **Confident**
- [x] Create and switch branches — **Confident**
- [x] Push to / pull from GitHub — **Confident**
- [x] clone vs fork — **Confident**
- [x] Merge — fast-forward vs merge commit — **Confident**
- [x] Rebase and when to use vs merge — **Confident**
- [x] stash / stash pop — **Confident**
- [x] cherry-pick — **Confident**
- [x] squash vs regular merge — **Confident**
- [x] reset (soft/mixed/hard) and revert — **Confident**
- [x] GitFlow, GitHub Flow, Trunk-Based — **Confident**
- [x] GitHub CLI for repos/PRs/issues — **Confident**

---

## Task 2 – Revisited Weak Spots

**1. crontab syntax** — re-did the schedule from Day 19.
```
┌ minute (0-59)
│ ┌ hour (0-23)
│ │ ┌ day of month (1-31)
│ │ │ ┌ month (1-12)
│ │ │ │ ┌ day of week (0-6, Sun=0)
│ │ │ │ │
0 3 * * *   /path/script.sh      # every day at 3:00 AM
*/5 * * * * /path/health.sh       # every 5 minutes
0 2 * * 0   /path/backup.sh        # 2 AM every Sunday
```
Re-learned: edit with `crontab -e`, list with `crontab -l`. The 5 fields are minute, hour, day-of-month, month, day-of-week.

**2. LVM order** — Physical Volume → Volume Group → Logical Volume.
```bash
pvcreate /dev/sdb          # 1. mark disk as a physical volume
vgcreate data_vg /dev/sdb  # 2. pool PVs into a volume group
lvcreate -L 5G -n data_lv data_vg   # 3. carve a logical volume out of the group
mkfs.ext4 /dev/data_vg/data_lv      # format and mount
```
Re-learned: the win is resizing — `lvextend` grows a volume across disks without repartitioning.

**3. vim basics** — `i` insert, `Esc` command mode, `:w` save, `:q` quit, `:wq` save+quit, `dd` delete line, `/text` search. Practiced editing a script end-to-end without leaving vim.

---

## Task 3 – Quick-Fire Questions (from memory)

1. **`chmod 755 script.sh`?** → Owner gets read/write/execute (7), group and others get read+execute (5,5). Makes a script executable by all, editable only by owner.
2. **Process vs service?** → A process is any running program instance. A service (daemon) is a process managed in the background, usually by systemd, often starting at boot.
3. **Find what's using port 8080?** → `ss -tulnp | grep 8080` (or `lsof -i :8080`).
4. **`set -euo pipefail`?** → Exit on any error (`-e`), error on unset variables (`-u`), and fail a pipeline if any stage fails (`-o pipefail`).
5. **`git reset --hard` vs `git revert`?** → `reset --hard` deletes commits and changes (rewrites history, destructive). `revert` adds a new commit that undoes a change (safe, history preserved).
6. **Branching strategy for 5 devs shipping weekly?** → GitHub Flow — simple, PR-based, `main` always deployable.
7. **`git stash`?** → Saves uncommitted work and cleans the working dir so I can switch context; restore later with `stash pop`. Used when an urgent task interrupts mid-feature.
8. **Run a script daily at 3 AM?** → cron: `0 3 * * * /path/script.sh`.
9. **`git fetch` vs `git pull`?** → fetch only downloads remote changes; pull = fetch + merge into the current branch.
10. **LVM and why over partitions?** → Logical Volume Manager abstracts storage so volumes can be resized, extended across multiple disks, and snapshotted — far more flexible than fixed partitions.

---

## Task 4 – Organize My Work
- [x] All daily submissions (day-1 → day-27) committed and pushed
- [x] `git-commands.md` up to date through Day 26
- [x] Shell scripting cheat sheet (Day 21) complete
- [x] GitHub profile and repos cleaned (Day 27)

---

## Task 5 – Teach It Back: Git branching for a non-developer

Imagine you're writing a book and you have one master copy. Before trying a risky new chapter, you photocopy the whole book and scribble your ideas on the *copy*. If the new chapter turns out great, you merge those pages back into the master. If it's bad, you toss the copy — the master was never touched. That copy is a **branch**. It lets you experiment safely, and lots of people can each work on their own copy at the same time without ruining the original. When everyone's happy, the good changes get combined back into the one master copy.

---

## Reflection
Strongest areas: shell scripting and Git — the daily hands-on projects (log rotation, backup, log analyzer) made them stick. Weakest: LVM and crontab syntax, both now revisited. Confident moving into the next phase.
