# Day 26 – GitHub CLI: Manage GitHub from the Terminal

## What I did today
Installed and authenticated the GitHub CLI (`gh`), then managed repos, issues, and PRs without leaving the terminal.

---

## Task 1 – Install and Authenticate

```bash
# install (pick your OS)
winget install --id GitHub.cli        # Windows
# brew install gh                     # macOS
# sudo apt install gh                 # Debian/Ubuntu

gh auth login                         # interactive: GitHub.com -> HTTPS -> browser
gh auth status
# ✓ Logged in to github.com account shubhs248
```

**What auth methods does `gh` support?**
- Web browser login (OAuth) — the easy default
- Personal Access Token (paste a PAT) — good for servers/CI
- SSH key based — `gh` can also upload an SSH key during login

---

## Task 2 – Working with Repositories

```bash
gh repo create gh-cli-test --public --readme     # create with a README
gh repo clone shubhs248/devops-git-practice      # clone via gh (no full URL needed)
gh repo view shubhs248/devops-git-practice       # repo details in terminal
gh repo list                                     # all my repos
gh repo view --web                               # open current repo in browser
gh repo delete gh-cli-test --yes                 # delete the test repo (careful!)
```

**Learning:** `gh repo create ... --public --readme` does in one line what used to take a browser + several clicks + a local `git init`.

---

## Task 3 – Issues

```bash
gh issue create --title "Fix disk alert threshold" \
  --body "Alert fires at 80%, should be 85%" --label bug
gh issue list                       # open issues
gh issue view 1                      # view issue #1
gh issue close 1                     # close it
```

**How could `gh issue` be used in a script/automation?**
A monitoring script could auto-open an issue when a check fails:
```bash
df -h / | awk 'NR==2{gsub("%","",$5); if($5>90) system("gh issue create --title \"Disk >90% on web-01\" --body \"Auto-filed by monitor\" --label ops")}'
```
So alerts become tracked, assignable tickets automatically.

---

## Task 4 – Pull Requests

```bash
git switch -c docs-update
echo "More docs" >> README.md && git commit -am "Update docs"
git push -u origin docs-update
gh pr create --fill                  # auto-fills title/body from commits
gh pr list                           # open PRs
gh pr view 2                         # status, reviewers, checks
gh pr merge 2 --squash               # merge from terminal
```

**Answers:**
- **`gh pr merge` methods:** `--merge` (merge commit), `--squash` (one commit), `--rebase` (replay commits).
- **Reviewing someone's PR with `gh`:** `gh pr checkout 5` to pull it locally and test, then `gh pr review 5 --approve` (or `--request-changes --body "..."`).

---

## Task 5 – GitHub Actions & Workflows (Preview)

```bash
gh run list --repo kubernetes/kubernetes      # list workflow runs on a public repo
gh run view <run-id>                          # status of a specific run
```

**How could `gh run` / `gh workflow` help in CI/CD?**
I could trigger workflows (`gh workflow run`), watch a deploy run from the terminal, gate a release script on a run's success, or pull logs of a failed pipeline — all scriptable without the web UI.

---

## Task 6 – Useful `gh` Tricks

```bash
gh api repos/shubhs248/devops-git-practice    # raw API call (JSON)
gh gist create notes.txt --public             # share a quick snippet
gh release create v1.0.0 --notes "First release"
gh alias set prs 'pr list'                     # now: gh prs
gh search repos "topic:devops stars:>1000"     # find popular DevOps repos
```

**Favorites I'll keep:** `gh pr create --fill`, `gh repo view --web`, and `gh alias set` for shortcuts.

---

## Submission checklist
- [x] `gh` installed, authenticated as `shubhs248`
- [x] Created repo, issue, and PR from the terminal
- [x] `git-commands.md` updated with `gh` commands (completes Days 22–26 reference)
- [x] `day-26-notes.md` written
