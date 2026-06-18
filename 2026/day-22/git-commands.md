# Git & GitHub Commands Reference

> My personal living reference, started on Day 22 and grown every day through Day 26.
> Every command here is one I actually ran in my `devops-git-practice` repo.
> Format for each: **what it does (1 line)** + **example**.

---

## 1. Setup & Config

```bash
git --version                              # Check Git is installed and see the version
git config --global user.name "Shubham Sharma"   # Set the name attached to your commits
git config --global user.email "you@example.com" # Set the email attached to your commits
git config --list                          # Show all current config (verify your identity)
git config --global core.editor "vim"      # Set your default editor for commit messages
git config --global init.defaultBranch main # Make new repos start on 'main' instead of 'master'
```

---

## 2. Basic Workflow

```bash
git init                        # Turn the current folder into a Git repository (.git/ appears)
git status                      # Show what's changed, staged, and untracked — your best friend
git add file.txt                # Stage one file for the next commit
git add .                       # Stage everything in the current directory
git commit -m "message"         # Save staged changes as a snapshot with a message
git commit -am "message"        # Stage tracked files AND commit in one step
git log                         # Full commit history (hash, author, date, message)
git log --oneline               # Compact one-line-per-commit history
git log --oneline --graph --all # Visual history of all branches (great for merge/rebase)
```

---

## 3. Viewing Changes

```bash
git diff                # Unstaged changes (working dir vs staging)
git diff --staged       # Staged changes (what will go into the next commit)
git show <hash>         # Show the full changes of a specific commit
git log -p file.txt     # History of a single file with diffs
git blame file.txt      # Show who last changed each line
```

---

## 4. Branching (Day 23)

```bash
git branch                      # List all local branches (* marks current)
git branch feature-1            # Create a new branch (does NOT switch to it)
git checkout feature-1          # Switch to feature-1 (classic way)
git switch feature-1            # Switch to feature-1 (modern, clearer way)
git checkout -b feature-2       # Create AND switch in one command
git switch -c feature-2         # Same as above, modern syntax
git branch -d feature-1         # Delete a branch (safe: refuses if unmerged)
git branch -D feature-1         # Force-delete a branch (even if unmerged)
git branch -m old-name new-name # Rename a branch
```

---

## 5. Remote / GitHub (Day 23)

```bash
git remote add origin https://github.com/shubhs248/devops-git-practice.git  # Link local repo to GitHub
git remote -v                    # List configured remotes and their URLs
git push -u origin main          # Push 'main' and set it to track origin (first push)
git push origin feature-1        # Push a specific branch to GitHub
git push                         # Push current branch (after -u is set)
git pull                         # Fetch + merge changes from the remote into current branch
git fetch                        # Download remote changes but DON'T merge them yet
git clone <url>                  # Copy a remote repo to your machine
git remote add upstream <url>    # Add the original repo (for forks) to sync later
git pull upstream main           # Sync your fork's main with the original repo
```

---

## 6. Merging & Rebasing (Day 24)

```bash
git merge feature-login          # Merge a branch into the current branch
git merge --no-ff feature-x      # Force a merge commit (no fast-forward)
git merge --squash feature-x     # Combine a branch's commits into ONE staged change
git rebase main                  # Replay current branch's commits on top of main (linear history)
git rebase --continue            # Continue a rebase after resolving conflicts
git rebase --abort               # Cancel a rebase and go back to before it started
git merge --abort                # Cancel an in-progress merge with conflicts
```

---

## 7. Stash & Cherry-Pick (Day 24)

```bash
git stash                        # Save uncommitted changes and clean the working dir
git stash push -m "wip: login"   # Stash with a descriptive message
git stash list                   # Show all stashes (stash@{0}, stash@{1}, ...)
git stash pop                    # Apply the latest stash AND remove it from the list
git stash apply                  # Apply a stash but KEEP it in the list
git stash apply stash@{1}        # Apply a specific stash by index
git stash drop stash@{0}         # Delete a specific stash
git cherry-pick <hash>           # Apply a single commit from another branch onto current
```

---

## 8. Undoing Changes — Reset & Revert (Day 25)

```bash
git reset --soft HEAD~1          # Undo last commit, KEEP changes staged
git reset --mixed HEAD~1         # Undo last commit, keep changes but UNSTAGE them (default)
git reset --hard HEAD~1          # Undo last commit and DISCARD all changes (destructive!)
git revert <hash>                # Create a NEW commit that undoes a previous commit (safe)
git restore file.txt             # Discard unstaged changes in a file
git restore --staged file.txt    # Unstage a file (keep the changes)
git reflog                       # Show EVERYTHING Git has done — your safety net after a reset
```

---

## 9. GitHub CLI — `gh` (Day 26)

```bash
gh auth login                    # Authenticate the GitHub CLI with your account
gh auth status                   # Check which account is logged in
gh repo create my-repo --public --readme   # Create a repo from the terminal
gh repo clone owner/repo         # Clone using gh
gh repo view owner/repo          # View repo details in the terminal
gh repo list                     # List all your repositories
gh repo view --web               # Open the current repo in your browser
gh issue create --title "Bug" --body "details" --label bug  # Create an issue
gh issue list                    # List open issues
gh issue view 12                 # View issue #12
gh issue close 12                # Close issue #12
gh pr create --fill              # Create a PR, auto-filling title/body from commits
gh pr list                       # List open pull requests
gh pr view 5                     # View details of PR #5
gh pr checkout 5                 # Check out PR #5 locally to review it
gh pr merge 5 --squash           # Merge PR #5 using squash
gh run list                      # List GitHub Actions workflow runs
gh workflow view                 # View a workflow's runs
gh api repos/owner/repo          # Raw GitHub API call from the terminal
gh search repos "topic:devops"   # Search GitHub repos from the terminal
```

---

*Started Day 22 · Last updated Day 26 · #90DaysOfDevOps*
