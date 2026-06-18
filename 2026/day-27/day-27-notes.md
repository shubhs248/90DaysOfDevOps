# Day 27 – GitHub Profile Makeover: Building My Developer Identity

> Branding day, not a coding day. Goal: make my GitHub read like a clear developer resume.

---

## Task 1 – Audit My Current Profile (the "before")

Looked at `github.com/shubhs248` as if I were a stranger / recruiter:

| Check | Before |
|-------|--------|
| Profile picture | Default avatar — not professional |
| Bio | Empty — no idea what I do |
| Pinned repos | Random forks, nothing curated |
| Repo descriptions | Mostly blank |
| Would a recruiter get it? | No — looked inactive and unclear |

**Verdict:** the profile didn't tell my story. Time to fix all of it.

---

## Task 2 – Profile README

Created the special repo `github.com/shubhs248/shubhs248` (same name as my username) so its `README.md` renders on my profile page. Kept it short, header + bullets, no badge overload. Full content saved in `profile-README.md` in this folder.

---

## Task 3 – Organize My Repositories

Created/cleaned these, each with a hyphenated name, one-line description, README, and a `.gitignore`:

| Repo | Description | Contains |
|------|-------------|----------|
| `90DaysOfDevOps` | My daily submissions for the 90 Days challenge | Fork, organized by `day-XX/` |
| `shell-scripts` | Reusable shell scripts from Days 16–21 | hello.sh, log_rotate.sh, backup.sh, log_analyzer.sh + README |
| `python-scripts` | Python practice from Days 7–15 | scripts + README listing each |
| `devops-notes` | Learning notes & cheat sheets | shell cheat sheet (Day 21), git-commands.md, organized by topic |

**Naming fix learned:** use `shell-scripts`, not `Shell Scripts` — hyphens, lowercase, no spaces.

---

## Task 4 – Pin My Best 6 Repos
Pinned: `90DaysOfDevOps`, `shell-scripts`, `python-scripts`, `devops-notes`, `devops-git-practice`, and the profile repo. Each has a description + README so the pins look intentional.

---

## Task 5 – Clean Up
- Deleted/archived empty and abandoned repos and stray forks.
- Renamed unclear repo names to descriptive, hyphenated ones.
- **Secret check:** scanned repos and commit history — no `.env`, API keys, or passwords committed. Added `.gitignore` entries (`.env`, `*.key`, `__pycache__/`) to keep it that way.

---

## Task 6 – Before & After

> Screenshots to attach here: `before.png` and `after.png` (add the two screenshots I took to this folder).

**3 things I improved and why:**
1. **Added a profile README + real bio** → a visitor instantly understands who I am and what I'm working on.
2. **Curated 6 pinned repos with descriptions** → my best work is front-and-center instead of random forks.
3. **Cleaned up names and removed clutter** → the profile looks active, intentional, and professional.

---

## Submission checklist
- [x] Profile README live at `github.com/shubhs248`
- [x] Repos organized, described, pinned
- [x] No secrets exposed
- [ ] Add before/after screenshots to this folder
