# Day 33 – Docker Compose: Multi-Container Basics 🐳

## Objective

Learn how to run and manage multi-container applications using Docker Compose.

Instead of manually creating:

- Networks
- Volumes
- Containers
- Environment variables

everything can be defined declaratively inside a single YAML file.

---

# 1. Docker Compose Installation

```bash
docker compose version
```

Output:

```bash
Docker Compose version v5.1.4
```

---

# 2. Dockerfile vs Docker Compose

| Dockerfile | Docker Compose |
|------------|----------------|
| Builds an image | Runs applications |
| Defines layers | Defines services |
| Uses `docker build` | Uses `docker compose up` |
| One container | Multiple containers |

### Mental Model

```text
Dockerfile
=
How to BUILD an image

Docker Compose
=
How to RUN applications
```

---

# 3. First Compose File (Nginx)

docker-compose.yml

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8085:80"
    volumes:
      - website-data:/usr/share/nginx/html

volumes:
  website-data:
```

Start:

```bash
docker compose up -d
```

Stop:

```bash
docker compose down
```

---

# 4. What Docker Compose Creates Automatically

Without Compose:

```bash
docker network create my-net
docker volume create my-data

docker run ...
docker run ...
```

With Compose:

```bash
docker compose up -d
```

Automatically creates:

```text
compose-basics_default
compose-basics_website-data
compose-basics-web-1
```

---

# 5. Service Names Become DNS Names

Example:

```yaml
services:
  db:
    image: mysql

  wordpress:
    image: wordpress
```

Inside WordPress:

```yaml
WORDPRESS_DB_HOST: db
```

NOT:

```text
localhost ❌
127.0.0.1 ❌
mysql ❌
```

Because:

```text
Service Name
↓
Docker DNS
↓
Container IP
```

This is exactly how Kubernetes Services work.

---

# 6. WordPress + MySQL Stack

docker-compose.yml

```yaml
services:
  db:
    image: mysql:8

    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: admin123
      MYSQL_ROOT_PASSWORD: root123

    volumes:
      - mysql-data:/var/lib/mysql

  wordpress:
    image: wordpress

    depends_on:
      - db

    ports:
      - "8086:80"

    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: admin123
      WORDPRESS_DB_NAME: wordpress

volumes:
  mysql-data:
```

---

# 7. Named Volumes

```yaml
volumes:
  mysql-data:
```

Mount:

```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

Benefits:

- Data persists after container removal
- Easy backup/restore
- Docker manages storage
- Best for databases

---

# 8. Why Two Volume Sections?

Usage:

```yaml
services:
  db:
    volumes:
      - mysql-data:/var/lib/mysql
```

Definition:

```yaml
volumes:
  mysql-data:
```

Think of it as:

```text
Use the volume
+
Create/manage the volume
```

---

# 9. depends_on

```yaml
depends_on:
  - db
```

Guarantees:

```text
Startup Order ✅
```

Does NOT guarantee:

```text
Application Readiness ❌
```

Real production systems use:

- Healthchecks
- Retries
- Readiness Probes
- Startup Probes

---

# 10. Environment Variables

.env

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=admin123
MYSQL_ROOT_PASSWORD=root123
WP_PORT=8087
```

docker-compose.yml

```yaml
MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

Benefits:

- Better security
- Easier environment management
- No hardcoded values
- Dev/QA/Prod separation

---

# 11. Debugging .env Problems

Most useful command:

```bash
docker compose config
```

It shows:

```text
Actual configuration after variable substitution
```

Common issue:

```yaml
MYSQL_PASSWORD: $MYSQL_PASSWORD
```

Wrong ❌

Correct:

```yaml
MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

---

# 12. Compose Commands Cheat Sheet

Start:

```bash
docker compose up
docker compose up -d
```

Status:

```bash
docker compose ps
```

Logs:

```bash
docker compose logs
docker compose logs -f
docker compose logs db
```

Stop:

```bash
docker compose stop
docker compose start
```

Remove:

```bash
docker compose down
docker compose down -v
```

Rebuild:

```bash
docker compose up --build -d
```

---

# 13. Interview Nuggets

### Difference between Dockerfile and Compose?

Dockerfile builds images.

Docker Compose runs multi-container applications.

---

### Why use named volumes?

To preserve application state and database data even after containers are recreated.

---

### Why doesn't `depends_on` solve everything?

Because it controls startup order, not service readiness.

---

### Why use `.env` files?

- Security
- Environment separation
- Easier maintenance
- No YAML changes

---

### What command helps debug variable substitution?

```bash
docker compose config
```

---

# Key Takeaways

```text
Dockerfile
=
Build Images

Docker Compose
=
Run Applications

Service Name
=
DNS Name

Named Volumes
=
Persistence

depends_on
=
Order, NOT readiness

.env
=
Configuration Management
```

---

# Completed Tasks

✅ Install & verify Docker Compose

✅ Single-container Compose application

✅ WordPress + MySQL stack

✅ Named volumes

✅ Automatic networking

✅ Service discovery via DNS

✅ Environment variables using .env

✅ Compose command practice

---

# References

Inspired by:
Shubham Londhe's 90 Days of DevOps roadmap.

GitHub:
https://github.com/shubhs248/90DaysOfDevOps
