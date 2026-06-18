# Day 23 – Git Branching & Working with GitHub

## What I did today
Learned branching, made my first push to GitHub, pulled a change made in the browser, and tried clone vs fork.

---

## Task 1 – Understanding Branches

**1. What is a branch in Git?**
A branch is a lightweight, movable pointer to a commit. It lets me work on a separate line of development without touching `main`.

**2. Why branches instead of committing everything to `main`?**
So unfinished or risky work stays isolated. `main` stays stable and deployable while features are built in parallel. Multiple people can work without stepping on each other.

**3. What is `HEAD`?**
`HEAD` is a pointer to "where I am right now" — usually the tip of the branch I currently have checked out. When I commit, `HEAD` (and the branch) moves forward.

**4. What happens to my files when I switch branches?**
Git swaps the working directory to match that branch's last commit. Files appear/disappear/change to reflect that branch. (Uncommitted changes can block the switch — that's where stash comes in, Day 24.)

---

## Task 2 – Branching Commands (Hands-On)

```bash
git branch                       # * main
git branch feature-1             # create feature-1
git switch feature-1             # switch to it
git switch -c feature-2          # create AND switch to feature-2 in one command

# git switch vs git checkout:
# switch = ONLY for changing branches (clearer, newer, safer)
# checkout = older, overloaded (switches branches AND restores files)

git switch feature-1
echo "feature-1 work" >> notes.txt
git add notes.txt
git commit -m "Add feature-1 only change"

git switch main
cat notes.txt        # the feature-1 line is NOT here — proof branches are isolated

git branch -d feature-2          # delete branch I no longer need
```

**Learning:** `git switch -c` is the everyday shortcut for "new branch, start working". A commit on `feature-1` simply doesn't exist on `main` until I merge.

---

## Task 3 – Push to GitHub

```bash
# created an EMPTY repo on github.com/shubhs248/devops-git-practice (no README)

git remote add origin https://github.com/shubhs248/devops-git-practice.git
git remote -v
# origin  https://github.com/shubhs248/devops-git-practice.git (fetch/push)

git push -u origin main          # first push sets upstream tracking
git push origin feature-1        # push the feature branch too
```
Both `main` and `feature-1` now show on GitHub.

**Difference between `origin` and `upstream`:**
- `origin` → my own remote (usually my fork or my repo) that I push to.
- `upstream` → the original repo I forked from, that I pull updates from but don't push to.
Convention, not a rule — they're just remote names.

---

## Task 4 – Pull from GitHub

```bash
# edited README.md directly on GitHub using the web editor, committed there
git pull
# Updating a1b2c3..d4e5f6, Fast-forward, README.md updated
```

**Difference between `git fetch` and `git pull`:**
- `git fetch` → downloads remote changes into my local copy but does **not** touch my working branch. I can inspect first.
- `git pull` → `fetch` + `merge` in one step; it downloads AND integrates into my current branch immediately.
`pull = fetch + merge`.

---

## Task 5 – Clone vs Fork

```bash
git clone https://github.com/kubernetes/kubernetes.git   # clone a public repo
# then forked it on GitHub and cloned MY fork:
git clone https://github.com/shubhs248/kubernetes.git
```

**Clone vs Fork:**
- **Clone** → a local copy of a repo on my machine (a Git operation).
- **Fork** → a server-side copy of a repo under my GitHub account (a GitHub feature).

**When to use which:**
- Clone when I just need the code locally (my own repo, or read-only use).
- Fork when I want to contribute to a project I don't have write access to — I fork, push to my fork, then open a PR.

**Keeping a fork in sync with the original:**
```bash
git remote add upstream https://github.com/kubernetes/kubernetes.git
git fetch upstream
git switch main
git merge upstream/main      # (or: git pull upstream main)
git push origin main
```

---

## Submission checklist
- [x] `feature-1` and `main` pushed and visible on GitHub
- [x] `git-commands.md` updated with branching + remote commands
- [x] `day-23-notes.md` written
