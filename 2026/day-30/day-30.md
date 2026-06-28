# Day 30 – Docker Images, Layers & Container Lifecycle 🐳

## Objective

Today's focus was understanding what Docker images really are, how layers work, and mastering the complete container lifecycle.

---

# 1. Images vs Containers

## Docker Image

An image is an immutable blueprint containing:

* Application binaries
* Runtime dependencies
* Libraries
* Environment variables
* Metadata
* Default commands (CMD/ENTRYPOINT)

Images are portable and can be shared through registries such as Docker Hub.

Examples:

```bash
docker pull nginx
docker pull ubuntu
docker pull alpine
```

---

## Docker Container

A container is a running instance of an image.

It provides:

* Process isolation
* Network namespaces
* Filesystem isolation
* Resource controls (cgroups)
* A writable layer on top of immutable image layers

Relationship:

```text
Image = Blueprint

Container = Running instance of the blueprint
```

---

# 2. Comparing Images

```bash
docker images
```

| Image  | Disk Usage | Content Size |
| ------ | ---------- | ------------ |
| alpine | 13 MB      | 3.93 MB      |
| ubuntu | 160 MB     | 45.3 MB      |
| nginx  | 241 MB     | 66 MB        |

### Why is Alpine so small?

Alpine:

* Uses BusyBox utilities
* Ships only minimal packages
* Targets container workloads

Ubuntu:

* Provides a complete Linux userspace
* Includes package managers and broader compatibility
* Better suited for development environments

---

# 3. Docker Layers

```bash
docker image history nginx
```

Observations:

* RUN instructions created large filesystem layers.
* COPY instructions added smaller layers.
* ENV, CMD, EXPOSE, ENTRYPOINT generated 0B metadata layers.

Example:

```text
RUN apt install nginx    → Adds filesystem content
COPY index.html          → Adds files
ENV APP_ENV=prod         → Metadata only (0B)
CMD ["nginx"]            → Metadata only (0B)
```

---

## Why Docker Uses Layers

Benefits:

* Faster builds through caching
* Reduced storage consumption
* Shared base images across applications
* Efficient image downloads
* Improved CI/CD performance

A Docker image is essentially:

```text
Image
=
Immutable Layer 1
+
Immutable Layer 2
+
Immutable Layer 3
...
```

Containers add:

```text
Writable Layer
```

on top of those read-only layers.

---

# 4. Container Lifecycle

Practiced commands:

```bash
docker create --name lifecycle-demo nginx
docker start lifecycle-demo
docker pause lifecycle-demo
docker unpause lifecycle-demo
docker stop lifecycle-demo
docker restart lifecycle-demo
docker kill lifecycle-demo
docker rm lifecycle-demo
```

Lifecycle:

```text
Image
 ↓
Created
 ↓
Running
 ↓
Paused
 ↓
Running
 ↓
Exited
 ↓
Removed
```

---

## Exit Codes

### Graceful Shutdown

```text
SIGTERM = 15
128 + 15 = 143
```

### Forced Termination

```text
SIGKILL = 9
128 + 9 = 137
```

Observed:

```bash
docker kill lifecycle-demo
```

Result:

```text
Exited (137)
```

---

# 5. Working with Running Containers

## View Logs

```bash
docker logs my-nginx
docker logs -f my-nginx
```

Equivalent to:

```text
logs     = cat logfile
logs -f  = tail -f logfile
```

---

## Execute Commands

Interactive:

```bash
docker exec -it my-nginx sh
```

Single command:

```bash
docker exec my-nginx ls /usr/share/nginx/html
```

The second approach is preferred for:

* Automation
* Monitoring
* Health checks
* CI/CD pipelines

---

# 6. Bridge Networking

Docker creates a virtual bridge:

```text
docker0
172.17.0.1
```

Containers receive:

```text
172.17.0.2
172.17.0.3
172.17.0.4
```

Example:

```bash
docker run -d -p 8090:80 nginx
```

Mapping:

```text
Host:      8090
Container: 80
```

Multiple containers can expose:

```text
Container A: 80 → Host 8090
Container B: 80 → Host 8091
Container C: 80 → Host 8092
```

because each container owns its own network namespace.

---

# 7. Volumes

Without volumes:

```text
Container removed
↓
Data lost
```

With volumes:

```bash
docker run \
-v /data/mysql:/var/lib/mysql \
mysql
```

Benefits:

* Persistent storage
* Disaster recovery
* Container recreation without data loss

Critical for:

* MySQL
* PostgreSQL
* Jenkins
* Nexus
* Prometheus
* Grafana

---

# 8. Cleanup Commands

Stop all containers:

```bash
docker stop $(docker ps -q)
```

Remove all containers:

```bash
docker rm $(docker ps -aq)
```

Remove dangling images:

```bash
docker image prune
```

Remove unused resources:

```bash
docker system prune
```

View Docker disk usage:

```bash
docker system df
```

Live resource monitoring:

```bash
docker stats
```

---

# Key Takeaways

* Images are immutable blueprints.
* Containers are isolated runtimes with writable layers.
* Docker layers enable caching and efficient storage.
* Bridge networking provides isolated IP spaces.
* Volumes are mandatory for stateful workloads.
* Understanding signals (143 vs 137) is critical for Kubernetes and production operations.
* Cleanup operations must be used carefully, especially with volumes.

---

# Interview Notes

**What is the difference between an image and a container?**

> An image is an immutable blueprint, while a container is a running instance of that image with its own processes, networking, namespaces, and writable layer.

**Why does Docker use layers?**

> To improve caching, reduce storage consumption, accelerate builds, and enable shared filesystem components across images.

**Why are volumes required in production?**

> Containers are ephemeral. Volumes ensure critical application data survives container restarts, upgrades, and failures.
