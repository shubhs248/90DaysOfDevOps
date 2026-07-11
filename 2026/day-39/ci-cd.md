# Day 39 – CI/CD Concepts

## Objective

Before writing a single pipeline, I wanted to understand **why CI/CD exists** and the problems it solves.

CI/CD is **not a tool**.

It is a **software delivery practice** implemented by tools like:

- Jenkins
- GitHub Actions
- Azure DevOps
- GitLab CI
- CircleCI
- Bamboo

The tools may differ, but the concepts remain the same.

---

# Why CI/CD Exists

Imagine a team of 5 developers working on the same application.

Every developer pushes their code to Git, and deployments are performed manually.

The deployment process usually looks like this:

```text
Developer Pushes Code
        │
        ▼
Merge to Main Branch
        │
        ▼
Login to Server
        │
        ▼
Pull Latest Code
        │
        ▼
Install Dependencies
        │
        ▼
Build Application
        │
        ▼
Run Tests
        │
        ▼
Restart Services
        │
        ▼
Verify Application
```

Doing this multiple times a day quickly becomes slow, repetitive, and error-prone.

---

# Problems with Manual Deployment

## "It Works on My Machine"

One of the most common problems in software development.

The application works perfectly on the developer's laptop but fails in QA or Production because of differences in:

- Operating System
- Software Versions
- Dependencies
- Environment Variables
- Configuration

This is one of the major reasons Docker became popular.

---

## Human Errors

Manual deployments can introduce mistakes such as:

- Wrong configuration
- Wrong branch deployed
- Forgotten restart
- Missing environment variables
- Incorrect dependency versions

---

## Slow Deployments

As the number of developers grows, manual deployments become increasingly difficult.

Imagine:

- 120 Developers
- 40 Deployments per day

If every deployment takes only 15 minutes:

```
40 × 15 = 600 minutes

= 10 hours
```

One engineer could spend an entire day only deploying software.

---

# What is Continuous Integration (CI)?

Continuous Integration is the practice of frequently merging code into a shared repository where every change is automatically:

- Built
- Tested
- Validated
- Packaged

Its primary goal is to catch problems early.

Typical CI activities include:

- Compile application
- Run Unit Tests
- Static Code Analysis (SonarQube)
- Build Docker Image
- Publish Artifact

CI ends when a **tested deployable artifact** is produced.

---

# What is Continuous Delivery (CD)?

Continuous Delivery starts after CI.

The tested artifact is automatically deployed to environments like:

- Development
- QA
- UAT
- Staging

A human approval is typically required before Production deployment.

Production deployment remains a business decision.

---

# What is Continuous Deployment?

Continuous Deployment extends Continuous Delivery.

The difference is simple:

There is **no manual approval**.

If every automated validation succeeds, the application is automatically deployed to Production.

---

# CI vs Continuous Delivery vs Continuous Deployment

| Continuous Integration | Continuous Delivery | Continuous Deployment |
|------------------------|---------------------|------------------------|
| Build & Test | Deploy to Staging/UAT | Deploy Automatically |
| Produce Artifact | Manual Approval Before Production | No Approval Required |
| Validate Code | Ready for Release | Release Happens Automatically |

---

# Build Once, Deploy Many

One of the most important CI/CD principles.

```
Developer Pushes Code
        │
        ▼
Build Application
        │
        ▼
Run Tests
        │
        ▼
Build Docker Image
        │
        ▼
Push Image to Registry
```

The image is **not rebuilt** later.

Instead, the exact same artifact is promoted through environments.

```
Docker Image

      │

      ▼

DEV

      │

      ▼

QA

      │

      ▼

UAT

      │

      ▼

Production
```

This guarantees that Production receives the exact same artifact that passed all testing.

---

# Why Don't We Rebuild Before Production?

Rebuilding introduces risk.

Even a small change such as:

- Updated dependency
- New base image
- Different build server
- Modified build script

can generate a different artifact.

Instead, organizations promote the same tested artifact through every environment.

This concept is called **Artifact Promotion**.

---

# Pipeline Anatomy

Every CI/CD pipeline consists of several building blocks.

```
Pipeline

↓

Trigger

↓

Stage

↓

Job

↓

Step
```

---

# Trigger

A Trigger defines **what starts the pipeline**.

Common triggers include:

- Git Push
- Pull Request
- Manual Run
- Scheduled Run (Cron)
- API Call

Example:

```
Developer Pushes Code

↓

Pipeline Starts
```

---

# Stage

A Stage represents a major phase of the pipeline.

Examples:

- Build
- Test
- Deploy

Think of Stages like chapters in a book.

---

# Job

A Job is a unit of work inside a Stage.

Multiple Jobs can exist inside one Stage and often execute in parallel.

Example:

```
Testing Stage

├── Ubuntu Tests

├── Windows Tests

└── macOS Tests
```

---

# Step

A Step is a single action inside a Job.

Examples:

- Checkout Code
- Install Dependencies
- Compile
- Run Tests
- Publish Artifact

Think:

**One command = One Step**

---

# Runner

A Runner is the machine that executes the pipeline.

Examples:

- GitHub-hosted Ubuntu Runner
- Azure DevOps Agent
- Jenkins Agent
- Self-hosted Linux Runner

The Runner executes every Step in the Job.

---

# Artifact

An Artifact is the output generated by the build.

Examples:

- Docker Image
- JAR File
- WAR File
- ZIP File
- Executable
- Binary

Artifacts are stored and later deployed through environments.

---

# Complete Pipeline Flow

```
Developer Writes Code

        │

        ▼

Git Push

        │

        ▼

Trigger

        │

        ▼

Build Stage

        │

        ▼

Run Tests

        │

        ▼

SonarQube Scan

        │

        ▼

Build Docker Image

        │

        ▼

Push Image to Registry

        │

────────── CI Ends Here ──────────

        │

Deploy to DEV

        │

Deploy to QA

        │

Deploy to UAT

        │

Manual Approval

        │

Deploy to Production

────────── CD Ends Here ──────────
```

---

# GitHub Actions Exploration

Repository Explored:

**FastAPI**

Workflow:

```
.github/workflows/test.yml
```

---

## Workflow Triggers

The workflow starts when:

- Code is pushed to `master`
- A Pull Request is opened
- Every Monday using a Cron schedule

This demonstrates that a single pipeline can have multiple triggers.

---

## Runner

```
runs-on:

ubuntu-latest
```

GitHub provisions a fresh Ubuntu virtual machine for the workflow.

---

## Checkout Action

```
uses: actions/checkout
```

The Runner starts empty.

Checkout downloads the repository onto the Runner before any build or testing begins.

Equivalent to:

```bash
git clone <repository>
```

---

## Path Filters

The workflow checks which files changed before running expensive jobs.

Example:

If only `README.md` changed, there is no need to:

- Build
- Test
- Scan

This reduces pipeline execution time and infrastructure cost.

---

## Scheduled Workflows

Running pipelines weekly helps identify issues caused by:

- Dependency updates
- Runner updates
- Expired certificates
- Infrastructure changes

even if developers haven't committed any new code.

---

# CI/CD Interview Questions

## What is CI/CD?

CI/CD is a software delivery practice that automates building, testing, and deploying applications to deliver software faster, more consistently, and with fewer human errors.

---

## Why does CI exist?

To automatically validate every code change before it reaches production.

---

## Where does CI end?

CI ends once the application has been:

- Built
- Tested
- Validated
- Packaged into a deployable artifact

---

## Where does CD begin?

CD begins once the deployable artifact is promoted through environments like DEV, QA, UAT, and Production.

---

## Difference between Continuous Delivery and Continuous Deployment?

Continuous Delivery requires manual approval before Production.

Continuous Deployment deploys automatically after all validations succeed.

---

## What is an Artifact?

A deployable output produced by the build process.

Examples include Docker Images, JAR files, ZIP archives, and compiled binaries.

---

## What is Artifact Promotion?

Deploying the exact same tested artifact through multiple environments instead of rebuilding it.

---

## Why don't we rebuild before Production?

Rebuilding may introduce differences in dependencies, base images, or build environments.

Deploying the same tested artifact guarantees consistency.

---

## What is a Runner?

The machine responsible for executing the pipeline.

Examples:

- GitHub Runner
- Azure DevOps Agent
- Jenkins Agent

---

## Difference between Stage, Job and Step?

Stage:

A major phase such as Build, Test or Deploy.

Job:

A unit of work inside a Stage.

Multiple Jobs can execute in parallel.

Step:

A single command or action executed inside a Job.

---

## Why use Pull Request validation?

To ensure code is tested before merging into the main branch.

---

## Why schedule pipelines?

To detect dependency, infrastructure, or environment issues even when no new code has been committed.

---

# Key Takeaways

- CI/CD is a practice, not a tool.
- CI focuses on building, testing, and validating code.
- CD focuses on delivering the validated artifact through environments.
- Build once, deploy many.
- Promote artifacts instead of rebuilding.
- Pipelines are made up of Triggers, Stages, Jobs, Steps, Runners, and Artifacts.
- GitHub Actions, Azure DevOps, Jenkins, and GitLab CI all implement the same core CI/CD concepts.
- Understanding the concepts is more important than memorizing tool-specific syntax.

---

# Personal Learning

Today was one of the biggest mindset shifts in my DevOps journey.

Earlier, I viewed CI/CD as "Jenkins" or "GitHub Actions."

Now I understand that those are simply tools implementing a software delivery practice.

The concepts—Triggers, Stages, Jobs, Steps, Runners, Artifacts, and Artifact Promotion—remain the same across every CI/CD platform.

With this foundation, I'm now ready to start building real pipelines in GitHub Actions and Azure DevOps with a much clearer understanding of what happens behind the scenes.
