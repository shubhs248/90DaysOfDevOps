# Day 42 – GitHub Actions Runners (GitHub Hosted & Self Hosted)

## 🎯 Objective

Understand where GitHub Actions workflows execute and learn the difference between GitHub-hosted and self-hosted runners. Configure a self-hosted runner, execute workflows on it, and understand how labels are used to target specific runners.

---

# What is a Runner?

A **Runner** is a machine that executes GitHub Actions workflow jobs.

```
Developer
    │
    ▼
GitHub Actions
    │
    ▼
Runner
    │
    ▼
Build → Test → Deploy
```

Without a runner, GitHub Actions has no machine to execute workflow steps.

---

# Types of Runners

## GitHub Hosted

- Managed by GitHub
- Fresh VM created for every workflow
- Automatically destroyed after execution
- Pre-installed development tools
- Auto scaling

Example

```yaml
runs-on: ubuntu-latest
```

---

## Self Hosted

- Managed by the user
- Runs on Laptop / VM / EC2 / VPS
- Persistent machine
- Custom software can be installed
- Suitable for private infrastructure

Example

```yaml
runs-on: self-hosted
```

---

# GitHub Hosted Runner Lab

Created workflows for

- ubuntu-latest
- windows-latest
- macos-latest

Verified

- Hostname
- Current User
- Python Version
- Git Version
- Docker Version (Ubuntu)

Observed

Docker was available on Ubuntu but not on macOS.

Error

```
docker: command not found
```

Reason

GitHub's macOS runner does not include Docker Engine by default.

---

# Matrix Strategy

Instead of writing three different jobs

```yaml
strategy:
  matrix:
    os:
      - ubuntu-latest
      - windows-latest
      - macos-latest

runs-on: ${{ matrix.os }}
```

GitHub automatically created three parallel jobs.

Benefits

- Less YAML
- Parallel execution
- Easier maintenance
- Cross-platform testing

---

# Self Hosted Runner Setup

Created folder

```
actions-runner
```

Downloaded runner package

Verified SHA256 checksum

Extracted package

Configured runner

```
./config.sh
```

Started runner

```
./run.sh
```

Runner status

```
Listening for Jobs
```

Verified in GitHub

```
Status: Idle
```

---

# Self Hosted Workflow

Created workflow

```yaml
runs-on: self-hosted
```

Workflow executed successfully on WSL Ubuntu.

Verified

- hostname
- pwd
- whoami

Created

```
shubham.txt
```

Confirmed file existed on local machine after workflow completion.

---

# Runner Workspace

GitHub created

```
_work/
```

Directory structure

```
_work/
├── _PipelineMapping
├── _temp
├── _tool
└── github-actions-practice
    └── github-actions-practice
```

Repository checkout location

```
GITHUB_WORKSPACE

↓

_work/github-actions-practice/github-actions-practice
```

Verified

```
find . -name shubham.txt
```

Output

```
./github-actions-practice/github-actions-practice/shubham.txt
```

---

# Labels

Added custom label

```
my-linux-runner
```

Workflow updated

```yaml
runs-on:
  - self-hosted
  - my-linux-runner
```

Purpose

Allows GitHub to select only runners matching all specified labels.

---

# GitHub Hosted vs Self Hosted

| Feature | GitHub Hosted | Self Hosted |
|----------|---------------|-------------|
| Managed By | GitHub | User |
| Machine | Temporary VM | Persistent Machine |
| Scaling | Automatic | Manual |
| Tools | Pre-installed | User Managed |
| Maintenance | GitHub | User |
| Network | Public | Can access private infrastructure |
| Best For | General CI/CD | Internal deployments, custom environments |

---

# Interview Questions

### What is a Runner?

A machine that executes GitHub Actions workflow jobs.

---

### Why use Self Hosted runners?

- Private infrastructure
- Internal Kubernetes clusters
- Custom software
- GPU workloads
- Compliance requirements

---

### Does GitHub SSH into Self Hosted runners?

No.

The runner agent initiates an outbound HTTPS connection and continuously polls GitHub for jobs.

---

### Why use Labels?

Labels allow workflows to target runners based on capabilities instead of machine names.

Example

```yaml
runs-on:
  - self-hosted
  - gpu
```

---

### Where is the repository cloned?

Into the directory pointed to by

```
GITHUB_WORKSPACE
```

For this lab

```
_work/github-actions-practice/github-actions-practice
```

---

# Commands Practiced

```bash
hostname
whoami
pwd
docker --version
python --version
git --version

./config.sh
./run.sh
find . -name shubham.txt
```

---

# Key Learnings

✅ Understood GitHub Hosted runners

✅ Used Matrix Strategy

✅ Configured a Self Hosted runner

✅ Executed workflow on WSL

✅ Explored runner workspace

✅ Used GITHUB_WORKSPACE

✅ Added custom labels

✅ Compared GitHub Hosted vs Self Hosted

---

# Status

✅ Day 42 Completed
