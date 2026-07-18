# Day 43 – GitHub Actions: Jobs, Steps, Variables & Conditionals

## 🎯 Objective

Learn how to control workflow execution using multiple jobs, environment variables, job outputs, dependencies, and conditional execution.

---

# 1. Jobs vs Steps

## Step
- Smallest unit of execution.
- Executes commands sequentially.
- Runs inside a job.

Example:

```yaml
steps:
  - run: echo "Build"
  - run: echo "Test"
```

---

## Job

- Collection of steps.
- Runs on its own runner (VM).
- Jobs are isolated from each other.

Example:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
```

---

# 2. Parallel vs Sequential Execution

By default, jobs run in parallel.

```
Job A

Job B

Job C
```

To execute sequentially:

```yaml
needs: build
```

Execution:

```
Build
   ↓
Test
   ↓
Deploy
```

---

# 3. Job Dependencies (needs)

Use `needs` to define execution order.

Single dependency:

```yaml
needs: build
```

Multiple dependencies:

```yaml
needs:
  - lint
  - test
```

GitHub waits until **all** required jobs complete successfully.

---

# 4. Environment Variables

Three scopes are available.

## Workflow Level

```yaml
env:
  APP_NAME: myapp
```

Accessible everywhere.

---

## Job Level

```yaml
jobs:
  build:
    env:
      ENVIRONMENT: staging
```

Accessible only within that job.

---

## Step Level

```yaml
steps:
  - env:
      VERSION: 1.0.0
```

Accessible only inside that step.

---

## Variable Precedence

```
Step
 ↑
Job
 ↑
Workflow
```

Closest scope wins.

---

# 5. GitHub Context

Useful built-in values.

```
github.actor
github.sha
github.ref_name
github.repository
github.event.head_commit.message
```

Example:

```yaml
${{ github.sha }}
```

---

# 6. Environment Variables vs Context

Environment Variables

```
$APP_NAME
```

Resolved by the runner.

GitHub Context

```
${{ github.actor }}
```

Resolved by GitHub before execution.

---

# 7. Job Outputs

Jobs are isolated.

To share values:

```
Step

↓

GITHUB_OUTPUT

↓

Job Output

↓

needs.job.outputs.value
```

Example:

```yaml
outputs:
  build_date: ${{ steps.date.outputs.today }}
```

Consumer:

```yaml
${{ needs.build.outputs.build_date }}
```

Use Outputs for:

- Docker image tags
- Version numbers
- Commit IDs
- Build metadata

---

# 8. Conditionals

Run jobs or steps only when conditions are true.

Example:

```yaml
if: github.ref_name == 'main'
```

Useful functions:

```
success()

failure()

always()

cancelled()
```

---

# 9. continue-on-error

```yaml
continue-on-error: true
```

Allows a step to fail without failing the job.

Useful for:

- Security scans
- Linting
- Notifications
- Cleanup

---

# 10. Smart Pipeline

```
            Push
              │
      ┌───────┴────────┐
      ▼                ▼
    Lint             Test
        \            /
         \          /
          ▼        ▼
          Summary
```

Summary waits for both jobs using:

```yaml
needs:
  - lint
  - test
```

---

# Key Interview Questions

### Difference between Job and Step?

A Step is a single action.
A Job is a collection of steps executed on a runner.

---

### Do jobs share files?

No.

Use Artifacts for files and Job Outputs for small values.

---

### What does needs do?

Creates dependencies between jobs.

---

### Difference between env and GitHub Context?

env → Runner variables

Context → Metadata evaluated by GitHub

---

### Why use continue-on-error?

To allow non-critical failures without stopping the workflow.

---

### When should always() be used?

Cleanup, notifications, artifact uploads and log collection.

---

## Key Takeaways

- Jobs run independently.
- Steps run sequentially inside a job.
- Jobs run in parallel by default.
- Use `needs` to create dependencies.
- Variables have three scopes.
- GitHub Context provides workflow metadata.
- Job Outputs pass values between jobs.
- Conditionals make workflows dynamic.
- Parallel pipelines reduce execution time.

---

## Status

✅ Completed Day 43
