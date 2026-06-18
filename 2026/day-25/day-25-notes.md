# Day 25 – Git Reset vs Revert & Branching Strategies

## What I did today
Learned to undo mistakes safely with `reset` and `revert`, and researched the branching strategies real teams use.

> Safety net of the day: `git reflog` — it logs everything Git did, so I can recover even after a `--hard` reset.

---

## Task 1 – Git Reset (Hands-On)

```bash
git commit -am "Commit A"
git commit -am "Commit B"
git commit -am "Commit C"

git reset --soft HEAD~1     # undo C: commit gone, changes STILL STAGED
git commit -m "Commit C again"

git reset --mixed HEAD~1    # undo C: commit gone, changes kept but UNSTAGED
git add . && git commit -m "Commit C again"

git reset --hard HEAD~1     # undo C: commit gone AND changes DELETED
```

**Answers:**
- **`--soft` vs `--mixed` vs `--hard`:**
  - `--soft` → moves the branch pointer back; changes stay **staged**.
  - `--mixed` (default) → moves pointer back; changes stay in working dir but **unstaged**.
  - `--hard` → moves pointer back and **discards** changes entirely.
- **Which is destructive and why:** `--hard` — it throws away your working changes with no easy undo (only `reflog` might save you).
- **When to use each:** `--soft` to re-commit differently (e.g., reword/recombine), `--mixed` to re-stage selectively, `--hard` to completely abandon recent work.
- **Reset on pushed commits?** No. Reset rewrites history; on shared/pushed branches it breaks everyone else's history. Use `revert` instead.

---

## Task 2 – Git Revert (Hands-On)

```bash
git commit -am "Commit X"
git commit -am "Commit Y"      # the one to undo
git commit -am "Commit Z"

git revert <hash-of-Y>         # creates a NEW commit that undoes Y
git log --oneline
# Y is STILL in history; a new "Revert Y" commit sits on top
```

**Answers:**
- **revert vs reset:** revert *adds* a new commit that reverses a change, leaving history intact. Reset *removes/moves* commits, rewriting history.
- **Why revert is safer for shared branches:** it doesn't rewrite history, so collaborators' repos stay consistent. Everyone just gets one extra "undo" commit.
- **When to use which:** revert on public/pushed branches; reset on local, un-pushed commits.

---

## Task 3 – Reset vs Revert Summary

| | `git reset` | `git revert` |
|---|---|---|
| What it does | Moves branch pointer to an earlier commit | Creates a new commit that undoes a previous one |
| Removes commit from history? | Yes (rewrites history) | No (history preserved) |
| Safe for shared/pushed branches? | No | Yes |
| When to use | Local, un-pushed cleanup | Undoing changes already shared with others |

---

## Task 4 – Branching Strategies

### 1. GitFlow
**How it works:** long-lived `main` (releases) and `develop` (integration), plus short-lived `feature/*`, `release/*`, and `hotfix/*` branches.
```
main ────●────────────●─────  (tagged releases)
          \           /
develop ───●──●──●──●─●─────
            \  /
feature ─────●●
```
**Used where:** products with scheduled, versioned releases (e.g., installed software, mobile apps).
**Pros:** very structured, clear release/hotfix separation. **Cons:** heavy, lots of branches, slow for continuous delivery.

### 2. GitHub Flow
**How it works:** one `main` branch that's always deployable + short-lived feature branches merged via PR.
```
main ──●──●──────●──●──  (always deployable)
        \        /
feature ─●──●──●─   (PR + review, then merge)
```
**Used where:** web apps and teams doing continuous deployment.
**Pros:** simple, fast, PR-centric. **Cons:** relies heavily on CI/tests; not ideal for multiple maintained versions.

### 3. Trunk-Based Development
**How it works:** everyone commits to `main` (trunk) frequently; branches live hours, not days; features hidden behind flags.
```
main ─●─●─●─●─●─●─●─  (tiny, frequent merges)
```
**Used where:** high-velocity teams with strong CI (Google, big tech).
**Pros:** minimal merge pain, fast integration. **Cons:** demands excellent automated testing and feature flags; risky without discipline.

**Answers:**
- **Startup shipping fast:** GitHub Flow (or trunk-based) — simple and quick.
- **Large team, scheduled releases:** GitFlow — structure handles parallel releases and hotfixes.
- **Favorite OSS project:** Checked Kubernetes on GitHub — it uses a GitHub-Flow-style PR model on `master`/`main` with release branches (`release-1.x`) cut for versions.

---

## Task 5 – git-commands.md update
Updated my reference to cover Days 22–25 fully: Setup, Basic Workflow, Branching, Remote, Merging & Rebasing, Stash & Cherry-Pick, and Reset & Revert.

---

## Submission checklist
- [x] Practiced reset (soft/mixed/hard) and revert
- [x] Reset vs Revert table + branching strategies documented
- [x] `git-commands.md` updated, `day-25-notes.md` written
