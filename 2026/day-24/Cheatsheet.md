# Day 24 - Advanced Git Cheatsheet

## Merge • Rebase • Squash • Stash • Cherry-pick

---

# Visualize History (Use Often)

```bash
git log --oneline --graph --decorate --all
```

Shows:

* Branches
* HEAD
* Merge commits
* Rebase history

---

# 1. Fast Forward Merge

## Scenario

```
A --- B --- C (main)
             \
              D --- E (feature)
```

Main has not changed.

## Commands

```bash
git switch main

git merge feature
```

Output:

```
Fast-forward
```

## Result

```
A --- B --- C --- D --- E
                      ▲
                    main
```

Git simply moves the `main` pointer.

No merge commit is created.

---

# 2. Merge Commit

## Scenario

Both branches changed.

```
          D --- E (feature)
         /
A --- B --- C
         \
          F (main)
```

## Commands

```bash
git switch main

git merge feature
```

Possible output

```
Merge made by the 'ort' strategy.
```

or

```
CONFLICT
```

if both modified the same lines.

Result

```
          D --- E
         /       \
A --- B --- C --- F --- M
```

M = Merge Commit

---

# Merge Conflict

Git cannot decide which version should survive.

Example

```
<<<<<<< HEAD
Production Hotfix
=======
Signup Page
>>>>>>> feature
```

Resolve manually.

Then

```bash
git add README.md

git commit
```

or if rebasing

```bash
git rebase --continue
```

---

# Merge Summary

Fast Forward

* no divergence
* pointer moves
* no merge commit

Merge Commit

* both branches changed
* preserves branch history

Merge Conflict

* same lines modified
* developer decides final content

---

# 3. Git Rebase

## Scenario

Feature branch is behind main.

```
feature

A --- B --- C --- D --- E

main

A --- B --- C --- M
```

## Commands

```bash
git switch feature

git rebase main
```

If conflict

```bash
vim README.md

git add README.md

git rebase --continue
```

Abort

```bash
git rebase --abort
```

Skip current commit

```bash
git rebase --skip
```

---

## Result

Old commits disappear.

Git creates NEW commits.

```
A --- B --- C --- M --- D' --- E'
```

Notice

```
D != D'
```

Different hashes.

Same code.

Different parent.

---

# Merge vs Rebase

Merge

* preserves history
* creates merge commits
* safe for shared branches

Rebase

* rewrites history
* linear history
* creates new commit hashes
* never rebase shared commits

---

# 4. Squash Merge

Feature

```
A
B
C
D
E
```

## Command

```bash
git switch main

git merge --squash feature
```

Nothing is committed yet.

Check staged changes

```bash
git diff --cached
```

Commit

```bash
git commit -m "Complete feature"
```

Result

Instead of

```
A
B
C
D
E
```

main gets

```
Complete feature
```

One clean commit.

---

# Squash vs Merge

Regular Merge

Keeps every commit.

Squash Merge

Combines all commits into one.

Good for

* feature branches
* cleanup
* readable history

---

# 5. Git Stash

Temporarily saves uncommitted work.

## Save

```bash
git stash
```

With message

```bash
git stash push -m "Payment API work"
```

List

```bash
git stash list
```

Example

```
stash@{0}

stash@{1}
```

Apply latest

```bash
git stash apply
```

Apply specific

```bash
git stash apply stash@{1}
```

Pop

```bash
git stash pop
```

Delete stash

```bash
git stash drop stash@{1}
```

Delete all

```bash
git stash clear
```

---

# Apply vs Pop

Apply

✅ restores changes

✅ stash remains

Pop

✅ restores changes

❌ stash deleted

---

# When to use Stash

* urgent production issue
* switching branches
* incomplete feature
* don't want to commit WIP

Think of stash as a temporary shelf.

---

# 6. Cherry Pick

Copies ONE commit onto another branch.

Feature

```
A
B
C
```

Need only B.

Commands

```bash
git switch main

git cherry-pick <commit_hash>
```

Find hash

```bash
git log --oneline
```

Example

```bash
git cherry-pick ee4c735
```

If conflict

```bash
vim README.md

git add README.md

git cherry-pick --continue
```

Abort

```bash
git cherry-pick --abort
```

Skip

```bash
git cherry-pick --skip
```

---

Result

Original

```
Feature

A
B
C
```

Main

```
X
Y
```

After cherry-pick

```
X
Y
B'
```

Notice

```
B != B'
```

Different hash.

Same changes.

---

# Cherry Pick Use Cases

* production hotfix
* copy one bug fix
* release branch fix
* avoid merging entire feature

---

# Commands You'll Actually Use

```bash
git merge feature

git merge --squash feature

git rebase main

git rebase --continue

git rebase --abort

git stash

git stash push -m "message"

git stash list

git stash apply

git stash apply stash@{1}

git stash pop

git stash drop stash@{1}

git stash clear

git cherry-pick <hash>

git cherry-pick --continue

git cherry-pick --abort

git log --oneline --graph --decorate --all
```

---

# Interview One-Liners

### Fast Forward Merge

Moves the branch pointer forward without creating a merge commit because the target branch has not diverged.

---

### Merge Commit

Created when both branches have new commits and Git needs to preserve both histories.

---

### Merge Conflict

Occurs when Git cannot automatically determine which changes should be kept, requiring manual resolution.

---

### Rebase

Replays commits onto a new base, creating new commit hashes and producing a cleaner, linear history.

---

### Squash Merge

Combines multiple feature commits into a single commit before merging.

---

### Git Stash

Temporarily stores uncommitted changes so you can switch branches without committing incomplete work.

---

### Cherry-pick

Copies a specific commit from one branch to another without merging the entire branch.
