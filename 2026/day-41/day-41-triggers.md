# Day 41 – Triggers & Matrix Builds

## Objective

Today I learned how GitHub Actions workflows can be triggered in different ways and how Matrix Builds help execute the same workflow across multiple environments in parallel.

---

# Task 1 – Pull Request Trigger

## Workflow

```yaml
name: pr-flow

on:
  pull_request:
    branches:
      - main

jobs:
  pr-check:
    runs-on: ubuntu-latest

    steps:
      - name: Print PR Branch
        run: echo "PR check running for branch: ${{ github.head_ref }}"
```

## What I Learned

- Runs whenever a Pull Request is opened, synchronized (new commits), or reopened.
- Used to validate changes before merging into the target branch.
- Commonly runs:
  - Unit Tests
  - Linting
  - Security Scans
  - Build Validation

---

# Task 2 – Scheduled Workflow

## Workflow

```yaml
name: scheduled-run

on:
  schedule:
    - cron: '0 0 * * *'

jobs:
  scheduled-check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Scheduled Message
        run: |
          echo "Running scheduled workflow"
```

## Cron Expressions

| Expression | Meaning |
|------------|---------|
| `0 0 * * *` | Every day at 12:00 AM UTC |
| `0 9 * * 1` | Every Monday at 9:00 AM UTC |
| `*/15 * * * *` | Every 15 minutes |

### Real-world Uses

- Nightly Builds
- Cleanup Jobs
- Database Backups
- Dependency Updates
- Health Checks

---

# Task 3 – Manual Trigger

## Workflow

```yaml
name: manual-trigger

on:
  workflow_dispatch:
    inputs:
      environment:
        description: "Select deployment environment"
        required: true
        type: choice
        options:
          - staging
          - production

jobs:
  manual-trigger-test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Print Environment
        run: |
          echo "Deploying to ${{ inputs.environment }}"
```

## What I Learned

- Triggered manually from the GitHub Actions UI.
- Can accept user inputs.
- Useful for production deployments and one-time operational tasks.

---

# Task 4 – Matrix Builds

## Workflow

```yaml
name: matrix

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ${{ matrix.os }}

    strategy:
      fail-fast: false

      matrix:
        os:
          - ubuntu-latest
          - windows-latest

        python-version:
          - "3.10"
          - "3.11"
          - "3.12"

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Build
        run: echo "Build on ${{ matrix.os }} with Python ${{ matrix.python-version }}"
```

---

# Matrix Expansion

| OS | Python |
|----|---------|
| Ubuntu | 3.10 |
| Ubuntu | 3.11 |
| Ubuntu | 3.12 |
| Windows | 3.10 |
| Windows | 3.11 |
| Windows | 3.12 |

Total Jobs:

```
2 Operating Systems
×

3 Python Versions

=

6 Parallel Jobs
```

---

# Exclude

```yaml
exclude:
  - os: windows-latest
    python-version: "3.10"
```

Remaining Jobs

```
6 - 1 = 5 Jobs
```

---

# Fail Fast

Default

```yaml
fail-fast: true
```

If one matrix job fails, GitHub cancels the remaining jobs.

---

```yaml
fail-fast: false
```

All matrix jobs continue to run even if one fails, providing a complete compatibility report.

---

# Useful GitHub Context Variables

| Variable | Purpose |
|-----------|---------|
| `${{ github.ref_name }}` | Branch name |
| `${{ github.head_ref }}` | Source PR branch |
| `${{ github.base_ref }}` | Target PR branch |
| `${{ github.event_name }}` | Triggering event |
| `${{ inputs.environment }}` | Manual workflow input |
| `${{ matrix.os }}` | Current Matrix OS |
| `${{ matrix.python-version }}` | Current Matrix Python Version |

---

# Key Learnings

- Different triggers solve different automation requirements.
- Pull Requests protect the main branch.
- Scheduled workflows automate recurring tasks.
- Manual workflows are useful for deployments.
- Matrix Builds eliminate duplicate YAML.
- Matrix jobs execute in parallel.
- Exclude removes unsupported combinations.
- Fail Fast controls whether remaining matrix jobs continue after a failure.

---

# Interview Questions

### What are Matrix Builds?

Matrix Builds allow GitHub Actions to execute the same job multiple times using different combinations of values.

---

### Why use Matrix Builds?

- Less YAML duplication
- Better maintainability
- Parallel execution
- Easy scalability

---

### Difference between fail-fast true and false?

**true**

Stops remaining matrix jobs after the first failure.

**false**

Allows every matrix job to complete, providing full visibility of failures.

---

### Why use Pull Request workflows?

To validate code before merging into the main branch and prevent broken code from reaching production.

---

## Repository

https://github.com/shubhs248/github-actions-practice

---

## 90 Days of DevOps Repository

https://github.com/shubhs248/90DaysOfDevOps/tree/master/2026/day-41
