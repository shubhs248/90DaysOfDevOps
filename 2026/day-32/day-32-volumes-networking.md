# Day 32 - Docker Volumes & Networking

## Objective

Today's goal was to understand two critical Docker concepts:

- Data Persistence (Volumes)
- Container Communication (Networking)

Containers are ephemeral by nature. Without external storage, data is lost when containers are removed. Similarly, applications need reliable communication mechanisms beyond changing IP addresses.

---

# Task 1: The Problem (Data Loss)

## Run PostgreSQL without an explicit volume

```bash
docker run -d \
  --name pg-test \
  -e POSTGRES_PASSWORD=admin123 \
  -p 5432:5432 \
  postgres:17
```

Created data:

```sql
CREATE DATABASE devops1;

\c devops1

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO employees(name)
VALUES ('Shubham'),
       ('Docker');

SELECT * FROM employees;
```

Output:

```text
 id |  name
----+---------
  1 | Shubham
  2 | Docker
```

## Observation

The official PostgreSQL image automatically creates an anonymous volume.

```bash
docker volume ls
```

```text
local     1061a03541c61cd2ab76112540ad90d4f97f509fa9046f43d9d95588b88ae150
```

Although data survives, the volume is difficult to identify and manage.

### Learning

- Container stop/start preserves data.
- Container removal destroys the writable layer.
- Anonymous volumes survive but are hard to reuse.
- Explicit named volumes are preferred for production workloads.

---

# Task 2: Named Volumes

Create a named volume:

```bash
docker volume create pg-data
```

Run PostgreSQL:

```bash
docker run -d \
  --name pg-prod \
  -e POSTGRES_PASSWORD=admin123 \
  -v pg-data:/var/lib/postgresql/data \
  postgres:17
```

Create persistent data:

```sql
CREATE DATABASE persistent_db;

\c persistent_db

CREATE TABLE notes (
    id SERIAL PRIMARY KEY,
    text VARCHAR(100)
);

INSERT INTO notes(text)
VALUES ('Volumes are awesome');

SELECT * FROM notes;
```

Output:

```text
 id |        text
----+---------------------
  1 | Volumes are awesome
```

Remove container:

```bash
docker rm -f pg-prod
```

Create a new container using the same volume:

```bash
docker run -d \
  --name pg-prod-v2 \
  -e POSTGRES_PASSWORD=admin123 \
  -v pg-data:/var/lib/postgresql/data \
  postgres:17
```

Verification:

```sql
\l

\c persistent_db

SELECT * FROM notes;
```

Output:

```text
 id |        text
----+---------------------
  1 | Volumes are awesome
```

## Learning

Named volumes separate application state from container lifecycle.

```text
Container removed ❌
Data survives ✅
```

---

# Task 3: Bind Mounts

Created:

```bash
mkdir nginx-bind-demo
cd nginx-bind-demo
```

index.html:

```html
<!DOCTYPE html>
<html>
<body>
    <h1>Day 32 - Bind Mounts</h1>
    <p>Hello from the HOST machine!</p>
</body>
</html>
```

Run Nginx:

```bash
docker run -d \
  --name bind-nginx \
  -p 8083:80 \
  -v $(pwd):/usr/share/nginx/html \
  nginx:alpine
```

Verification:

```bash
curl http://localhost:8083
```

Modified index.html on host:

```html
<p>Hello after applying changes from the HOST machine!</p>
```

Refreshed browser:

```bash
curl http://localhost:8083
```

Changes appeared instantly.

## Learning

### Named Volume

- Docker-managed storage
- Best for databases and application data
- High portability

### Bind Mount

- Host-managed storage
- Best for development workflows
- Live code updates without rebuilds

---

# Task 4: Docker Networking Basics

List networks:

```bash
docker network ls
```

Output:

```text
bridge
host
kind
none
```

Default network:

```text
bridge
```

Testing communication:

```bash
docker exec -it bind-nginx ping pg-prod-v2
```

Result:

```text
ping: bad address 'pg-prod-v2'
```

Using IP:

```bash
docker exec -it bind-nginx ping -c 2 172.17.0.5
```

Result:

```text
Success
```

## Learning

Default bridge supports:

- IP-based communication ✅
- Name-based communication ❌

---

# Task 5: Custom Networks

Create network:

```bash
docker network create my-app-net
```

Run containers:

```bash
docker run -dit \
  --name app1 \
  --network my-app-net \
  ubuntu bash

docker run -dit \
  --name app2 \
  --network my-app-net \
  ubuntu bash
```

Verification:

```bash
docker exec -it app1 getent hosts app2
```

Output:

```text
172.19.0.3      app2
```

## Learning

Custom bridge networks provide:

- Automatic DNS resolution
- Service discovery
- Better isolation
- Easier microservice communication

Applications communicate using:

```text
DB_HOST=db
```

instead of:

```text
DB_HOST=172.x.x.x
```

---

# Task 6: Putting Everything Together

Create network:

```bash
docker network create my-stack-net
```

Create volume:

```bash
docker volume create pg-stack-data
```

Run database:

```bash
docker run -d \
  --name db-stack \
  --network my-stack-net \
  -v pg-stack-data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=admin123 \
  postgres:17
```

Run application:

```bash
docker run -dit \
  --name app-stack \
  --network my-stack-net \
  ubuntu bash
```

Verify DNS:

```bash
docker exec -it app-stack getent hosts db-stack
```

Output:

```text
172.20.0.2      db-stack
```

## What survives after recreation?

| Component | Survives |
|-----------|-----------|
| Database Data | ✅ |
| Container ID | ❌ |
| Container IP | ❌ |
| DNS Name | ✅ |

---

# Key Takeaways

## Container

- Ephemeral
- IDs change
- IPs change

## Network

Provides stable service discovery.

```text
db-stack
```

instead of:

```text
172.20.0.2
```

## Volume

Provides persistent storage independent of containers.

---

# Production Perspective

Use Named Volumes for:

- PostgreSQL
- MySQL
- Jenkins Home
- Nexus Blobstores
- Redis persistence

Use Bind Mounts for:

- Development
- Source code
- Configuration files
- Static website testing
- Hot reload workflows

---

# Kubernetes Connection

Docker:

```text
Container
↓
Network
↓
Volume
```

Kubernetes:

```text
Pod
↓
Service
↓
PersistentVolumeClaim
```

Today's concepts directly map to:

- Docker Named Volume → Kubernetes PVC
- Docker DNS → Kubernetes Service Discovery
- Custom Bridge Networks → Cluster Networking

These foundations enable resilient, scalable, and stateful containerized applications.
