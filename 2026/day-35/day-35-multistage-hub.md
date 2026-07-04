# Day 35 – Multi-Stage Builds & Docker Hub 🚀

## Objective

Learn how real teams build optimized, secure images and distribute them using Docker Hub.

---

# Project Structure

```text
day-35/
└── app/
    ├── app.js
    ├── package.json
    ├── Dockerfile.single
    ├── Dockerfile.multistage
    └── .dockerignore
```

---

# Application

## app.js

```javascript
console.log("Hello from Day 35 - Multi Stage Builds!");
```

---

## package.json

```json
{
  "name": "day-35-app",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  }
}
```

---

# Single-Stage Build

```dockerfile
FROM node:24-alpine

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

CMD ["node", "app.js"]
```

Build:

```bash
docker build -f Dockerfile.single -t day35-single:v1 .
```

Image Size:

```text
58.2 MB
```

---

# Multi-Stage Build

```dockerfile
# Stage 1: Builder
FROM node:24-alpine AS builder

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

# Stage 2: Runtime
FROM node:24-alpine

WORKDIR /app

COPY --from=builder /app .

RUN adduser -D appuser

USER appuser

CMD ["node", "app.js"]
```

Build:

```bash
docker build -f Dockerfile.multistage -t day35-multi:v1 .
```

Image Size:

```text
57.6 MB
```

---

# Why Was The Difference Small?

Our application:

```javascript
console.log("Hello World");
```

Already uses:

```dockerfile
FROM node:24-alpine
```

There are:

- No build tools
- No React
- No TypeScript
- No Babel
- No large node_modules
- No compilation steps

In real applications, multi-stage builds save hundreds of megabytes.

---

# Multi-Stage Build Flow

```text
Builder Stage
├── npm install
├── Build tools
├── Temporary files
└── Dependencies

            │
            ▼

Runtime Stage
└── Only application artifacts
```

---

# COPY --from

```dockerfile
COPY --from=builder /app .
```

Meaning:

Copy files from the previous build stage called `builder`.

Benefits:

- Smaller images
- Better security
- Faster deployments
- Reduced attack surface

---

# Docker Hub Workflow

Login:

```bash
docker login
```

Tag:

```bash
docker tag day35-multi:v1 shubhs248/day35-node:v1
```

Push:

```bash
docker push shubhs248/day35-node:v1
```

Pull:

```bash
docker pull shubhs248/day35-node:v1
```

Verification successful.

---

# Image Versioning

Bad:

```text
my-api:latest
```

Good:

```text
my-api:v1
my-api:1.0.0
my-api:2026.07
my-api:git-a1b2c3d
```

Benefits:

- Reproducibility
- Easy rollback
- Better traceability

---

# .dockerignore

```text
.git
node_modules
*.log
.env
.vscode
README.md
Dockerfile.single
Dockerfile.multistage
```

Benefits:

- Smaller build contexts
- Faster builds
- Better security
- Prevent accidental secret leaks

---

# Non-Root Containers

```dockerfile
RUN adduser -D appuser

USER appuser
```

Why?

Principle of least privilege.

Benefits:

- Better security
- Reduced blast radius
- Production best practice

---

# FROM scratch

```dockerfile
FROM scratch
```

Means:

Absolutely nothing exists inside the image.

No:

- shell
- package manager
- libc
- utilities
- bash

Only the copied application binary exists.

Perfect for statically compiled Go applications.

---

# Important Commands

Build:

```bash
docker build -f Dockerfile.single -t day35-single:v1 .
```

Multi-stage:

```bash
docker build -f Dockerfile.multistage -t day35-multi:v1 .
```

Tag:

```bash
docker tag day35-multi:v1 shubhs248/day35-node:v1
```

Push:

```bash
docker push shubhs248/day35-node:v1
```

Pull:

```bash
docker pull shubhs248/day35-node:v1
```

Cleanup:

```bash
docker rmi day35-single:v1
docker rmi day35-multi:v1
docker rmi shubhs248/day35-node:v1
```

---

# Key Learnings

- Multi-stage builds separate build and runtime environments.
- Smaller images improve security and deployment speed.
- Docker Hub acts as a centralized image registry.
- Explicit version tags are better than `latest`.
- `.dockerignore` reduces build context size.
- Containers should run as non-root users.
- `FROM scratch` creates minimal runtime images.

---

# Day 35 Status

✅ Single-stage build  
✅ Multi-stage build  
✅ Docker Hub push  
✅ Version tagging  
✅ Non-root user  
✅ .dockerignore  
✅ Image cleanup  

---

Repository:

https://github.com/shubhs248/90DaysOfDevOps

Docker Hub:

https://hub.docker.com/r/shubhs248/day35-node
