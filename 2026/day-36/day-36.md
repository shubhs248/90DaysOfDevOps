# Day 36 – Docker Project: Dockerizing a Real Full-Stack Application

## Objective

Today's goal was to understand how a real-world multi-container application is Dockerized and deployed using Docker Compose.

Instead of creating another sample application, I chose to work with an existing production-style project to understand how frontend, backend, database, networking, and Docker all fit together.

---

# Project

**Repository:** DevBoard

Technology Stack:

- React + Vite (Frontend)
- Go (Backend API)
- PostgreSQL
- Docker
- Docker Compose

Architecture:

```
Browser
    │
    ▼
Frontend (React + Vite)
    │
    │  /api/*
    ▼
Go Backend
    │
    ▼
PostgreSQL
    │
Named Volume
```

---

# Project Structure

```
devboard/
├── backend/
│   ├── Dockerfile
│   ├── main.go
│   ├── go.mod
│   └── ...
│
├── frontend/
│   ├── Dockerfile
│   ├── src/
│   ├── package.json
│   └── ...
│
├── init/
│   └── postgres/
│
├── docker-compose.yml
├── .env.example
├── .dockerignore
└── README.md
```

---

# Docker Concepts Used

## Multi-stage Docker Builds

Both frontend and backend use multi-stage builds.

Benefits:

- Smaller images
- Cleaner runtime image
- Build tools not included in production
- Better security

---

## Non-root Containers

The backend runs using:

```
USER nonroot
```

instead of running as root.

Benefits:

- Better security
- Production best practice
- Limits container privileges

---

## Environment Variables

Instead of hardcoding credentials inside Compose,

```
POSTGRES_USER=${POSTGRES_USER}
```

values are injected from:

```
.env
```

Advantages:

- Configuration separated from code
- Different environments can use different values
- Secrets are not committed to Git

---

# Docker Compose Components

## Services

Three services are defined:

- postgres
- backend
- frontend

---

## Named Volume

```
pgdata:/var/lib/postgresql/data
```

Purpose:

- Database survives container recreation
- Data remains persistent

---

## Custom Network

Docker Compose automatically creates:

```
devboard_default
```

All services communicate over this network.

Docker DNS allows services to communicate simply using service names:

```
backend
postgres
frontend
```

instead of IP addresses.

---

## Healthchecks

Postgres healthcheck:

```
pg_isready
```

Backend waits until PostgreSQL becomes healthy before starting.

This prevents startup failures.

---

## depends_on

```
depends_on:
  postgres:
    condition: service_healthy
```

Backend does not start immediately.

It waits until PostgreSQL is actually ready.

---

# Database Initialization

The project mounts:

```
./init/postgres
```

to

```
/docker-entrypoint-initdb.d
```

During the very first startup PostgreSQL automatically executes:

- Schema creation
- Index creation
- Seed data

These scripts execute only once because the database is stored inside a named volume.

---

# Frontend → Backend Communication

One interesting concept was the Vite proxy.

Development:

```
Browser
      │
localhost:5173
      │
      ▼
Proxy
      │
localhost:8080
```

Docker Compose:

```
Browser
      │
localhost:8080
      │
Frontend Container
      │
      ▼
backend
```

Notice the backend hostname:

```
http://backend:8080
```

This works because Docker Compose provides built-in DNS.

---

# URL Rewrite

Frontend receives:

```
/api/projects
```

Proxy rewrites it into:

```
/projects
```

before forwarding it to the Go backend.

This matches the backend routes.

---

# Build Process

Running

```bash
docker compose up --build
```

performed the following steps:

1. Build backend image
2. Build frontend image
3. Pull PostgreSQL image
4. Create network
5. Create named volume
6. Create containers
7. Initialize PostgreSQL
8. Execute SQL scripts
9. Wait for healthcheck
10. Start backend
11. Start frontend

---

# Docker Resources Created

Containers:

- frontend
- backend
- postgres

Network:

```
devboard_default
```

Volume:

```
devboard_pgdata
```

Images:

- devboard-backend
- devboard-frontend
- trainwithshubham/devboard-backend
- trainwithshubham/devboard-frontend

---

# Troubleshooting Learned

Initially,

```
curl http://localhost:8080/projects
```

returned HTML instead of JSON.

Reason:

The request was reaching the frontend container instead of the backend.

Correct understanding:

```
Browser
    │
Frontend
    │
Proxy
    │
Backend
    │
Database
```

Only requests beginning with

```
/api
```

are forwarded to the backend.

---

# Commands Practiced

```bash
docker compose up --build

docker compose ps

docker volume ls

docker network ls

docker images

docker logs

curl http://localhost:8080

curl http://localhost:8080/api/projects
```

---

# Key Learnings

- Docker Compose is Infrastructure as Code.
- Service names automatically become DNS names.
- Named volumes preserve data beyond container lifetime.
- Healthchecks are better than simply waiting for containers to start.
- Environment variables should be separated from Compose files.
- Multi-stage builds create smaller and cleaner images.
- Real-world applications often use frontend proxies to communicate with backend APIs.
- Initialization scripts are executed only when a fresh database volume is created.

---

# Challenges Faced

- Docker Desktop was not running, causing Docker commands inside WSL to fail.
- Initially misunderstood why `/projects` returned HTML.
- Learned how frontend proxy configuration routes `/api/*` requests to the backend.

---

# Final Takeaway

This project was significantly more valuable than a basic Docker demo.

Instead of only learning Docker commands, I understood how a real application is deployed using Docker Compose, how containers communicate using Docker DNS, how environment variables are injected, how databases are initialized, and how frontend proxying connects the browser to backend APIs.

This felt much closer to the kind of applications I expect to work with in a real DevOps role.
