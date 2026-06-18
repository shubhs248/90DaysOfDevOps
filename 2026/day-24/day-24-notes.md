# Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry Pick

## What I did today
Practiced how branches come back together (merge, rebase, squash) and how to handle context-switching (stash) and picking single commits (cherry-pick). All hands-on in `devops-git-practice`.

> Handy throughout the day: `git log --oneline --graph --all` to *see* what each operation does to history.

---

## Task 1 – Git Merge

```bash
git switch -c feature-login
echo "login page" >> app.txt && git commit -am "Add login page"
echo "login styles" >> app.txt && git commit -am "Style login"

git switch main
git merge feature-login
# Fast-forward  ->  main just moved forward, no merge commit
```
Then I forced a divergence:
```bash
git switch -c feature-signup
echo "signup" >> app.txt && git commit -am "Add signup"
git switch main
echo "main hotfix" >> other.txt && git commit -am "Hotfix on main"   # main moved ahead too
git merge feature-signup
# Merge made by the 'recursive' strategy  ->  a MERGE COMMIT was created
```

**Answers:**
- **Fast-forward merge:** when `main` hasn't moved since the branch was created, Git just slides `main`'s pointer forward. No extra commit.
- **When does Git make a merge commit?** When both branches have new commits (history diverged). Git creates a new commit with two parents to tie them together.
- **Merge conflict:** when the same lines of the same file changed differently on both branches, Git can't decide — it pauses and marks the file with `<<<<<<<`, `=======`, `>>>>>>>`. I edit to keep the right version, then `git add` + `git commit`.

I intentionally created one by editing the same line of `app.txt` on two branches:
```bash
# after conflict markers appear, I edited the file, then:
git add app.txt
git commit          # completes the merge
```

---

## Task 2 – Git Rebase

```bash
git switch -c feature-dashboard
echo "d1" >> dash.txt && git commit -am "Dashboard 1"
echo "d2" >> dash.txt && git commit -am "Dashboard 2"

git switch main
echo "m1" >> main.txt && git commit -am "Main moved ahead"

git switch feature-dashboard
git rebase main
# replays Dashboard 1 & 2 ON TOP of main's latest commit
```

**Answers:**
- **What rebase does:** it takes my branch's commits, sets them aside, moves the branch base to the tip of `main`, then re-applies my commits one by one. Result: a straight, linear history.
- **vs merge:** merge keeps the real (branching) history and adds a merge commit; rebase rewrites my commits to look like they happened after `main` — cleaner straight line, no merge commit.
- **Why never rebase pushed/shared commits:** rebase creates *new* commit hashes. If others already based work on the old commits, I've rewritten shared history and their repos diverge — painful conflicts. Rule: rebase only local, unpushed work.
- **Rebase vs merge — when:** rebase to keep a clean linear history on my *local* feature branch before sharing; merge to preserve true history and integrate shared branches safely.

---

## Task 3 – Squash Merge vs Merge Commit

```bash
git switch -c feature-profile
git commit -am "fix typo"
git commit -am "formatting"
git commit -am "rename var"
git commit -am "tweak"

git switch main
git merge --squash feature-profile
git commit -m "Add profile feature"     # all 4 commits become ONE on main
```
vs regular merge:
```bash
git switch -c feature-settings
git commit -am "settings 1"
git commit -am "settings 2"
git switch main
git merge feature-settings              # keeps both commits + a merge commit
```

**Answers:**
- **Squash merge:** collapses all of a branch's commits into a single new commit on the target branch.
- **When to use:** squash when the branch has lots of noisy WIP commits ("typo", "fix", "oops") and I only want a clean one-liner on `main`. Regular merge when each commit is meaningful and worth keeping.
- **Trade-off:** squashing loses the granular per-commit history of the feature — you can't see the step-by-step anymore.

---

## Task 4 – Git Stash

```bash
echo "wip change" >> app.txt           # uncommitted work
git switch main
# error: cannot switch, local changes would be overwritten  (if conflicting)

git stash                              # save WIP, working dir is clean now
git switch other-branch                # now I can move freely
# ...do urgent work...
git switch -                           # back to my branch
git stash pop                          # bring my WIP back

git stash push -m "wip: dashboard tweak"   # stash with a label
git stash list
# stash@{0}: On feature: wip: dashboard tweak
# stash@{1}: WIP on main: ...
git stash apply stash@{1}              # apply a specific one (keeps it in list)
```

**Answers:**
- **`stash pop` vs `stash apply`:** `pop` applies the stash and removes it from the list; `apply` applies it but keeps it (useful if I want to apply the same WIP to multiple branches).
- **Real-world use:** an urgent bug comes in while I'm mid-feature. I stash, fix the bug on another branch, come back, and pop my work-in-progress.

---

## Task 5 – Cherry Picking

```bash
git switch -c feature-hotfix
git commit -am "commit 1"
git commit -am "commit 2 (the one I want)"
git commit -am "commit 3"
git log --oneline      # grab the hash of commit 2

git switch main
git cherry-pick <hash-of-commit-2>     # only that ONE commit lands on main
git log --oneline      # confirms only commit 2 was applied
```

**Answers:**
- **What cherry-pick does:** copies a single specific commit from one branch and applies it onto the current branch (as a new commit with a new hash).
- **Real use:** porting one urgent bug fix to a release branch without bringing the whole feature branch along.
- **What can go wrong:** conflicts if the target branch differs; and it can create duplicate-looking commits (same change, different hash) which can confuse later merges.

---

## Submission checklist
- [x] Practiced merge, rebase, squash, stash, cherry-pick hands-on
- [x] `git-commands.md` updated with merge/rebase/stash/cherry-pick
- [x] `day-24-notes.md` written
