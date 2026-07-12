# Day 40 – My First GitHub Actions Workflow

## Objective

Today marked my first hands-on experience with GitHub Actions.

After understanding the theory behind CI/CD, I created and executed my first cloud-based CI pipeline. The objective was to understand not only how to write a workflow but also what happens behind the scenes when GitHub executes it.

---

# Repository

Repository Name:

```
github-actions-practice
```

---

# Workflow File

Location:

```
.github/workflows/hello-again.yml
```

---

# Final Workflow

```yaml
name: Hello Workflow

on:
  push:

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print Greeting
        run: echo "Hello from GitHub Actions!"

      - name: Print Current Date & Time
        run: date

      - name: Print Current Branch
        run: |
          echo "Branch: ${{ github.ref_name }}"

      - name: Print Runner Operating System
        run: uname -a

      - name: List Repository Files
        run: ls -la
```

---

# Workflow Anatomy

## name

Provides a friendly name for the workflow displayed in the GitHub Actions tab.

Example:

```yaml
name: Hello Workflow
```

---

## on

Defines the event that triggers the workflow.

For today's exercise:

```yaml
on:
  push:
```

The workflow executes every time code is pushed to the repository.

---

## jobs

A workflow can contain one or multiple jobs.

Today's workflow contains one job:

```yaml
jobs:
  greet:
```

---

## runs-on

Specifies which Runner will execute the job.

```yaml
runs-on: ubuntu-latest
```

GitHub automatically provisions an Ubuntu virtual machine.

---

## steps

A job is divided into multiple steps.

Each step performs one specific task.

---

## uses

Executes a reusable GitHub Action.

Example:

```yaml
uses: actions/checkout@v4
```

This downloads the repository onto the Runner.

---

## run

Executes shell commands on the Runner.

Examples:

```yaml
run: echo "Hello"

run: date

run: uname -a

run: ls -la
```

These are standard Linux commands executed on the GitHub Runner.

---

# What Happens Behind the Scenes

```
Developer Pushes Code

        │

        ▼

GitHub receives Push Event

        │

        ▼

Workflow Triggered

        │

        ▼

GitHub Creates Ubuntu Runner

        │

        ▼

Runner is Empty

        │

        ▼

actions/checkout Downloads Repository

        │

        ▼

Runner Executes Every run Command

        │

        ▼

Logs Generated

        │

        ▼

Workflow Completes
```

---

# Output Observed

The workflow successfully printed:

- Hello from GitHub Actions
- Current Date & Time
- Current Branch
- Runner Operating System
- Repository Files

This confirmed that all commands were executed successfully on the GitHub-hosted Ubuntu Runner.

---

# What I Learned

## GitHub Runner

A Runner is simply a machine that executes workflow jobs.

In today's workflow, GitHub automatically provisioned an Ubuntu virtual machine.

---

## actions/checkout

The Runner starts empty.

Without checking out the repository, the Runner would not have access to project files.

`actions/checkout` clones the repository onto the Runner.

---

## GitHub Context Variables

GitHub provides built-in variables during workflow execution.

Example:

```yaml
${{ github.ref_name }}
```

This automatically resolves to the branch that triggered the workflow.

Example output:

```
Branch: main
```

---

## Linux Commands Inside Pipelines

One important realization was that GitHub Actions does not introduce a new scripting language.

The Runner is simply a Linux machine.

Everything under `run:` is just a shell command executed on that machine.

---

# Challenge Faced

While extending the workflow, I encountered an error:

```
Invalid workflow file
```

GitHub reported a YAML syntax error.

After reviewing the workflow, I corrected the YAML syntax and pushed the changes again.

The workflow executed successfully.

This demonstrated an important lesson:

Pipeline failures are not always application failures. Sometimes they occur before the Runner even starts because the workflow definition itself is invalid.

---

# Interview Questions

## What is GitHub Actions?

GitHub Actions is GitHub's built-in CI/CD platform used to automate software development workflows such as building, testing, and deploying applications.

---

## What is a Runner?

A Runner is the machine that executes workflow jobs.

It may be:

- GitHub Hosted
- Self Hosted

---

## Why do we use actions/checkout?

Because the Runner starts empty.

The checkout action downloads the repository before executing any build or test commands.

---

## Where does run execute?

The commands inside `run:` execute on the GitHub Runner.

They do not execute on the developer's local machine.

---

## Difference between uses and run?

**uses**

Executes an existing GitHub Action.

**run**

Executes shell commands.

---

## Why use step names?

Step names make workflow logs easier to read and debug.

---

## What is `${{ github.ref_name }}`?

A built-in GitHub Actions context variable that returns the branch name which triggered the workflow.

---

# Key Takeaways

- GitHub Actions workflows are stored inside `.github/workflows/`.
- Every workflow starts with a trigger.
- Jobs execute on Runners.
- Runners are simply machines.
- `actions/checkout` downloads the repository.
- `run` executes Linux shell commands.
- GitHub provides built-in context variables.
- Reading pipeline logs is as important as writing the workflow itself.
- Debugging YAML errors is part of everyday CI/CD work.

---

# Personal Reflection

Today transformed CI/CD from theory into practice.

Instead of simply learning the syntax, I understood what actually happens after a `git push`:

GitHub provisions a Runner, downloads the repository, executes every step, captures logs, and reports the final status.

Understanding this execution flow makes GitHub Actions far less intimidating and provides a strong foundation for learning more advanced CI/CD concepts such as multiple jobs, artifacts, caching, secrets, and deployments.
