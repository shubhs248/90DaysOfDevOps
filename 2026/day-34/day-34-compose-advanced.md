# Day 34 – Docker Compose: Real-World Multi-Container Apps 🚀

## Objective

Build a production-like multi-container application using:

- Flask Web Application
- PostgreSQL Database
- Redis Cache
- Docker Compose
- Healthchecks
- Restart Policies
- Named Networks & Volumes
- Labels
- Service Dependencies
- Scaling Experiments

---

# Project Structure

```text
day-34/
├── docker-compose.yml
└── app/
    ├── Dockerfile
    ├── app.py
    └── requirements.txt
```

---

# Application Architecture

```text
                   Browser
                      |
                      v
                localhost:5000
                      |
                      v
              +----------------+
              |   Flask App    |
              |   (web)        |
              +----------------+
                  |        |
                  |        |
                  v        v
           +----------+  +---------+
           | Postgres |  |  Redis  |
           |   (db)   |  | (cache) |
           +----------+  +---------+

All services communicate over:

backend network
```

---

# Dockerfile

```dockerfile
FROM python:3.12

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

# Why This Layer Order Matters

Good:

```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

Benefits:

- Dependency installation gets cached
- Source code changes do not reinstall packages
- Faster rebuilds

Example:

```bash
docker compose up --build -d
```

Output:

```text
CACHED [2/5] WORKDIR /app
CACHED [3/5] COPY requirements.txt .
CACHED [4/5] RUN pip install -r requirements.txt
[5/5] COPY . .
```

Only the application layer was rebuilt.

---

# requirements.txt

```text
flask
psycopg2-binary
redis
```

---

# app.py

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return {
        "message": "Docker Compose Day 34 - Rebuilt Successfully!",
        "status": "running"
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

# docker-compose.yml

```yaml
services:

  web:
    build: ./app

    ports:
      - "5000:5000"

    depends_on:
      db:
        condition: service_healthy

      redis:
        condition: service_started

    networks:
      - backend

    labels:
      owner: shubham
      component: web


  db:
    image: postgres:17

    restart: always

    environment:
      POSTGRES_PASSWORD: admin123

    volumes:
      - pg-data:/var/lib/postgresql/data

    healthcheck:
      test:
        - CMD-SHELL
        - pg_isready -U postgres

      interval: 10s
      timeout: 5s
      retries: 5

    networks:
      - backend

    labels:
      owner: shubham
      component: db


  redis:
    image: redis:7-alpine

    restart: always

    networks:
      - backend

    labels:
      owner: shubham
      component: redis


volumes:
  pg-data:


networks:
  backend:
```

---

# Healthchecks

```yaml
healthcheck:
  test:
    - CMD-SHELL
    - pg_isready -U postgres

  interval: 10s
  timeout: 5s
  retries: 5
```

Purpose:

- Wait until PostgreSQL accepts connections
- Prevent application startup failures
- Better than relying on container startup order alone

---

# depends_on

```yaml
depends_on:
  db:
    condition: service_healthy

  redis:
    condition: service_started
```

Important:

```text
service_started
≠
service_healthy
```

Postgres needs initialization before applications can connect.

Redis starts almost instantly, so `service_started` is enough.

---

# Restart Policies

## restart: always

Use for:

- Databases
- Monitoring systems
- Critical infrastructure
- Reverse proxies

Behavior:

- Restart after crashes
- Restart after daemon restarts
- Restart after server reboots

---

## restart: on-failure

Use for:

- Migration jobs
- Workers
- Batch processing

Behavior:

- Restart only if exit code is non-zero

---

## restart: unless-stopped

Use for:

- Development environments
- Local stacks

Behavior:

- Same as always
- Does not restart after an intentional stop

---

# Named Volumes

Definition:

```yaml
volumes:
  pg-data:
```

Usage:

```yaml
volumes:
  - pg-data:/var/lib/postgresql/data
```

Benefits:

- Data persistence
- Container recreation safety
- Easier backups
- Production readiness

---

# Explicit Networks

```yaml
networks:
  backend:
```

Usage:

```yaml
networks:
  - backend
```

Benefits:

- Stable internal DNS
- Better isolation
- Easier troubleshooting

Examples:

```text
db
redis
web
```

instead of:

```text
172.22.0.4
172.22.0.5
```

---

# Labels

```yaml
labels:
  owner: shubham
  component: web
```

Benefits:

- Better organization
- Easier filtering
- Monitoring integrations
- Production metadata

---

# Scaling Experiment

Command:

```bash
docker compose up -d --scale web=3
```

Result:

```text
Bind for 0.0.0.0:5000 failed:
port is already allocated
```

Reason:

```text
Host Port 5000
=
Only one listener allowed
```

Docker Compose:

```text
Browser
   |
localhost:5000
   |
Single Container
```

Kubernetes:

```text
Browser
   |
Service
   |
+-----+-----+-----+
|Pod1 |Pod2 |Pod3 |
+-----+-----+-----+
```

Services provide:

- Load balancing
- Stable DNS
- Virtual IPs
- Replica abstraction

---

# Useful Commands

## Validate Compose

```bash
docker compose config
```

---

## Start

```bash
docker compose up -d
```

---

## Build & Rebuild

```bash
docker compose up --build -d
```

---

## View Logs

```bash
docker compose logs

docker compose logs db

docker compose logs web
```

---

## Show Running Services

```bash
docker compose ps
```

---

## Keep Volumes

```bash
docker compose down
```

---

## Remove Volumes

```bash
docker compose down -v
```

---

## Remove Built Images

```bash
docker compose down --rmi local
```

---

# Key Learnings

- Docker Compose orchestrates multiple services from a single YAML file.
- Healthchecks are better than startup ordering alone.
- Named volumes preserve data.
- Explicit networks provide stable DNS communication.
- Restart policies depend on workload characteristics.
- Docker layer caching dramatically improves build speed.
- Simple scaling breaks when host ports are involved.
- Kubernetes Services solve replica networking and load balancing.

---

# Day 34 Status

✅ Flask Application  
✅ PostgreSQL Database  
✅ Redis Cache  
✅ Dockerfile Integration  
✅ build: in Compose  
✅ Healthchecks  
✅ depends_on Conditions  
✅ Restart Policies  
✅ Named Volumes  
✅ Explicit Networks  
✅ Labels  
✅ Scaling Experiment  

---

# GitHub Repository

https://github.com/shubhs248/90DaysOfDevOps

# Credits

Inspired by the amazing #90DaysOfDevOps journey created by Shubham Londhe.
