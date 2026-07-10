# Day 38 – YAML Basics

## Objective

Before learning Kubernetes, Azure DevOps Pipelines, GitHub Actions, Helm, or Ansible, I learned the language that all of them speak: **YAML**.

YAML is **not a programming language**.

It is a **human-readable configuration language** used to describe data and infrastructure.

---

# Where YAML Fits in DevOps

```text
Linux
   │
Shell Scripting
   │
Git
   │
Docker
   │
Docker Compose
   │
YAML  ← Today
   │
   ├── Azure DevOps Pipelines
   ├── GitHub Actions
   ├── Kubernetes
   ├── Helm
   ├── Ansible
   └── ArgoCD
```

YAML is the common language used by almost every modern DevOps tool.

---

# YAML Fundamentals

## 1. Key-Value Pairs

Everything starts with a key and its value.

```yaml
name: Shubham
role: DevOps Engineer
experience_years: 7
learning_status: true
```

### Data Types

| Type | Example |
|------|---------|
| String | `name: Shubham` |
| Integer | `experience_years: 7` |
| Boolean | `learning: true` |
| Float | `version: 1.5` |

---

## 2. Lists

### Block Style (Most Common)

```yaml
tools:
  - Linux
  - Git
  - Docker
  - Jenkins
  - Kubernetes
```

### Inline Style

```yaml
hobbies: [Reading, Travelling, Singing]
```

### Interview Question

**Q. What are the two ways of writing a list in YAML?**

Answer:

- Block List
- Inline List

Block lists are preferred in production because they are easier to read.

---

## 3. Nested Objects

Example:

```yaml
server:
  name: practice
  ip: 0.0.0.9
  port: 5000

database:
  host: 0.0.0.10
  name: practice_db
  credentials:
    user: db_user
    password: db_password
```

Think of it as:

```
Server
 ├── Name
 ├── IP
 └── Port

Database
 ├── Host
 ├── Name
 └── Credentials
      ├── User
      └── Password
```

---

# Indentation

YAML does **not** use `{}` like JSON.

Instead, **spaces define relationships**.

Correct:

```yaml
server:
  name: web01
```

Incorrect:

```yaml
server:
name: web01
```

The second example makes `name` a completely different top-level key.

### Remember

> **Spaces are the braces of YAML.**

Never use **tabs**.

---

# Multi-line Strings

## Using `|`

Preserves line breaks.

```yaml
command: |
  apt update
  apt install -y nginx
  service nginx start
```

Output:

```
apt update
apt install -y nginx
service nginx start
```

Use for:

- Shell scripts
- SQL scripts
- Certificates
- Configuration files

---

## Using `>`

Folds multiple lines into one.

```yaml
comment: >
  This server configuration
  is for practice purpose only.
  It includes basic setup.
```

Output:

```
This server configuration is for practice purpose only. It includes basic setup.
```

Use for:

- Long descriptions
- Documentation
- Comments

---

# Boolean Best Practices

Preferred:

```yaml
learning: true
```

Avoid:

```yaml
learning: yes
learning: no
learning: on
learning: off
```

Some YAML parsers interpret them differently.

Always use:

```yaml
true
false
```

---

# YAML Validation

Install:

```bash
sudo apt update
sudo apt install yamllint
```

Validate:

```bash
yamllint person.yml
yamllint server.yml
```

---

# Common Yamllint Errors

## Missing document start

```
missing document start "---"
```

Optional style warning.

Many Kubernetes manifests include:

```yaml
---
```

Docker Compose usually doesn't.

---

## Wrong newline character

```
expected \n
```

Windows uses:

```
CRLF
```

Linux uses:

```
LF
```

Fix:

```bash
dos2unix server.yml
```

or convert CRLF → LF in VS Code.

---

## Trailing Spaces

Example:

```
password: admin␠
```

Remove unnecessary spaces.

---

## No newline at end of file

Unix text files should always end with one empty line.

---

# YAML vs JSON

JSON

```json
{
  "name": "Shubham",
  "role": "DevOps"
}
```

YAML

```yaml
name: Shubham
role: DevOps
```

YAML is:

- More readable
- Less verbose
- Easier to maintain
- Supports comments

---

# Docker Compose Connection

Compose isn't a different language.

It is simply YAML.

Example:

```yaml
services:

  web:

    build: ./app

    ports:
      - "5000:5000"
```

Read it naturally:

- There is a services object.
- Inside it is a web service.
- It is built from `./app`.
- It exposes port 5000.

---

# Kubernetes Connection

Example:

```yaml
deployment:
  metadata:
    name: nginx

  spec:
    replicas: 3

    template:
      containers:
        - name: nginx
          image: nginx:latest
```

Read it naturally:

> There is a Deployment named **nginx**.
> Kubernetes should maintain **3 replicas**.
> Each replica runs a container using the **nginx:latest** image.

---

# Interview Questions

## Q1. What is YAML?

YAML is a human-readable configuration language used to describe data and infrastructure. It is widely used in Docker Compose, Kubernetes, Azure DevOps, GitHub Actions, Helm, and Ansible.

---

## Q2. Why do DevOps tools prefer YAML over JSON?

Because YAML is:

- Easier for humans to read
- Less verbose
- Supports comments
- Easier to maintain
- Better suited for configuration files

---

## Q3. Why is indentation important?

Indentation defines relationships between objects.

Unlike JSON, YAML doesn't use braces `{}`.

Instead, spaces define the structure.

Incorrect indentation changes the meaning of the configuration or causes parsing errors.

---

## Q4. Difference between `true` and `"true"`?

```yaml
learning: true
```

Boolean.

```yaml
learning: "true"
```

String.

---

## Q5. Difference between `|` and `>`?

`|`

- Preserves line breaks.
- Used for scripts and configurations.

`>`

- Converts multiple lines into one.
- Used for descriptions and documentation.

---

## Q6. What are the two ways to write lists?

1. Block list

```yaml
tools:
  - Docker
  - Kubernetes
```

2. Inline list

```yaml
tools: [Docker, Kubernetes]
```

---

## Q7. What is `yamllint`?

A YAML validator that checks:

- Syntax
- Indentation
- Formatting
- Common mistakes
- Style issues

---

## Q8. Where have you used YAML?

- Docker Compose
- Kubernetes
- Azure DevOps Pipelines
- GitHub Actions
- Helm
- Ansible
- ArgoCD

---

## Q9. Explain nested objects.

Nested objects group related information together.

Example:

```yaml
database:
  host: localhost
  credentials:
    user: admin
    password: secret
```

The credentials belong to the database object.

---

## Q10. Can YAML store different data types?

Yes.

YAML supports:

- Strings
- Integers
- Floats
- Booleans
- Lists
- Objects

---

# Commands Used

```bash
touch person.yml
touch server.yml

cat person.yml
cat server.yml

sudo apt install yamllint

yamllint person.yml
yamllint server.yml

dos2unix server.yml
```

---

# Key Takeaways

- YAML is a configuration language, not a programming language.
- Everything is built using keys, values, lists, and nested objects.
- Indentation defines relationships.
- Never use tabs.
- `|` preserves line breaks.
- `>` folds lines into a single paragraph.
- Validate YAML using `yamllint`.
- Docker Compose, Kubernetes, Azure DevOps, GitHub Actions, Helm, and Ansible all use YAML.

---

# Personal Learning

The biggest mindset shift today was realizing that I was already writing YAML through Docker Compose.

Earlier, I looked at Compose files as Docker syntax.

Now I understand they are simply YAML files describing containers, networks, volumes, ports, and services.

Learning YAML first makes reading Kubernetes manifests and CI/CD pipelines significantly easier because the syntax remains the same—the keywords change, but the grammar doesn't.
