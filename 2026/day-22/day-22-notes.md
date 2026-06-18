# Day 22 – Introduction to Git: My First Repository

## What I did today
Set up Git from scratch, created my first repo (`devops-git-practice`), built multiple commits, and started my living `git-commands.md` reference.

---

## Task 1 – Install and Configure Git

```bash
git --version
# git version 2.43.0

git config --global user.name "Shubham Sharma"
git config --global user.email "you@example.com"

git config --list
# user.name=Shubham Sharma
# user.email=you@example.com
```

**Learning:** `--global` writes to `~/.gitconfig`, so the identity applies to every repo on my machine. Every commit I make is stamped with this name and email.

---

## Task 2 – Create My Git Project

```bash
mkdir devops-git-practice && cd devops-git-practice
git init
# Initialized empty Git repository in .../devops-git-practice/.git/

git status
# On branch main
# No commits yet
# nothing to commit (create/copy files and use "git add" to track)

ls -la .git
# HEAD  config  description  hooks/  info/  objects/  refs/
```

**What `git status` told me:** I'm on `main`, there are no commits yet, and nothing is being tracked. It literally tells me my next move.

**What's inside `.git/`:**
- `HEAD` → points to the branch I'm currently on
- `config` → this repo's settings
- `objects/` → where Git stores every commit, file, and tree (the actual database)
- `refs/` → pointers to branches and tags

---

## Task 3 – Git Commands Reference
Created `git-commands.md` (kept in the repo, updated every day since). Organized into Setup & Config, Basic Workflow, and Viewing Changes. See the file for the full, growing list.

---

## Task 4 – Stage and Commit

```bash
git add git-commands.md
git status              # shows git-commands.md under "Changes to be committed"
git commit -m "Add initial git commands reference"
git log
# commit a1b2c3... (HEAD -> main)
# Author: Shubham Sharma
#     Add initial git commands reference
```

---

## Task 5 – Build History (multiple commits)

```bash
# edit git-commands.md, add branching section
git add git-commands.md
git commit -m "Add basic workflow commands"

# edit again
git commit -am "Add viewing changes commands"

# edit again
git commit -am "Document config commands with examples"

git log --oneline
# d4e5f6a Document config commands with examples
# c3d4e5f Add viewing changes commands
# b2c3d4e Add basic workflow commands
# a1b2c3d Add initial git commands reference
```

**Learning:** `git commit -am` stages and commits tracked files in one step. `--oneline` is how I'll always read history quickly.

---

## Task 6 – Understanding the Git Workflow (in my own words)

**1. Difference between `git add` and `git commit`?**
`git add` moves changes into the staging area (a "draft" of what I want to save). `git commit` permanently records that staged snapshot into the repo history. Add = prepare, commit = save.

**2. What does the staging area do? Why not commit directly?**
The staging area lets me choose *exactly* what goes into a commit. I can edit 5 files but commit only 2 related ones, keeping each commit focused and meaningful. Direct commit would force "all or nothing".

**3. What does `git log` show?**
The commit history — each commit's hash, author, date, and message, newest first. It's the timeline of the project.

**4. What is `.git/` and what if I delete it?**
It's the entire repository database — all history, branches, and config live there. Delete it and the folder becomes a normal folder again: all version history is gone, though the current files remain.

**5. Working directory vs staging area vs repository?**
- **Working directory** → the actual files I edit.
- **Staging area** → the "on deck" set of changes I've marked for the next commit.
- **Repository** → the committed history stored in `.git/`.
Flow: edit (working dir) → `git add` (staging) → `git commit` (repository).

---

## Submission checklist
- [x] Multiple commits visible in `git log --oneline`
- [x] `git-commands.md` created and committed
- [x] `day-22-notes.md` written
