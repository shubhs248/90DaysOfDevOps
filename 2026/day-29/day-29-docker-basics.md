# Day 29 - Docker Basics

## Task 1: What is Docker?

### What is a Container and Why Do We Need Them?

A container is a lightweight, isolated environment that packages an application along with all its dependencies, libraries, and runtime requirements. Containers ensure that applications behave consistently across development, testing, and production environments.

Benefits:

* Eliminates "works on my machine" problems.
* Faster startup compared to virtual machines.
* Lightweight because containers share the host kernel.
* Easy to distribute and reproduce using images.

---

### Containers vs Virtual Machines

| Containers             | Virtual Machines               |
| ---------------------- | ------------------------------ |
| Share host OS kernel   | Each VM has its own OS kernel  |
| Lightweight            | Resource intensive             |
| Start in seconds       | Boot time can take minutes     |
| Minimal overhead       | Hypervisor overhead            |
| Best for microservices | Best for complete OS isolation |

### Linux vs Windows Containers

* Linux containers require a Linux kernel.
* Windows containers require a Windows kernel.
* Linux containers on Windows typically work through WSL2 or Docker Desktop, which provides a Linux kernel layer.

---

### Docker Architecture

```text
Docker Client
      |
      v
Docker Daemon (dockerd)
      |
      +------ Images
      |
      +------ Containers
      |
      +------ Networks
      |
      +------ Volumes
      |
      v
Docker Registry (Docker Hub, ECR, ACR, Harbor, Nexus)
```

#### Docker Client

The Docker CLI (`docker`) is the interface used by users to send commands to the Docker daemon.

#### Docker Daemon

`dockerd` manages images, containers, networks, volumes, and communication with registries.

#### Docker Images

Images are read-only templates containing applications and their dependencies.

#### Docker Containers

Containers are running instances of Docker images with their own writable layer.

#### Docker Registries

Registries store and distribute Docker images. Examples include Docker Hub, Amazon ECR, Azure ACR, Harbor, Nexus, and Artifactory.

---

## Task 2: Installation

### Verify Installation

```bash
docker --version
```

Output:

```text
Docker version 29.5.2
```

### Hello World

```bash
docker run hello-world
```

Learnings:

1. Docker client contacted the daemon.
2. The daemon pulled the image from Docker Hub.
3. The daemon created a container.
4. The container executed `/hello`.
5. Output was streamed back to the terminal.

---

## Task 3: Running Real Containers

### Run Nginx

```bash
docker run -d \
  --name my-nginx \
  -p 8080:80 \
  nginx
```

Flags:

* `-d` → Detached mode.
* `--name` → Custom container name.
* `-p 8080:80` → Host port 8080 maps to container port 80.

Verification:

```bash
docker ps
curl http://localhost:8080
```

Result:

```text
Welcome to nginx!
```

---

### Interactive Ubuntu Container

```bash
docker run -it --name ubuntu-lab ubuntu bash
```

* `-i` → Keep STDIN open.
* `-t` → Allocate a pseudo-terminal.

Observations:

```bash
ps -ef
```

Output:

```text
PID 1 -> bash
```

Containers run only the processes started inside them and do not include services such as systemd, cron, or sshd by default.

---

## Container Lifecycle

```text
docker run
   ↓
docker create
   ↓
docker start
   ↓
PID 1 starts
   ↓
Container runs
   ↓
PID 1 exits
   ↓
Container stops
```

Container lifetime equals the lifetime of PID 1.

---

## Writable Layer Experiment

Inside the container:

```bash
echo "Hello Docker" > /tmp/test.txt
```

After:

```bash
docker stop ubuntu-lab
docker start ubuntu-lab
docker exec -it ubuntu-lab bash
```

The file still existed.

Conclusion:

* `docker stop/start` preserves the writable layer.
* `docker rm` destroys the writable layer.
* Volumes are required only when persistence beyond container deletion is needed.

---

## Important Commands

### List Running Containers

```bash
docker ps
```

### List All Containers

```bash
docker ps -a
```

### Stop a Container

```bash
docker stop <container>
```

### Remove a Container

```bash
docker rm <container>
```

### View Logs

```bash
docker logs my-nginx
```

Docker logs capture STDOUT and STDERR from container processes.

### Execute Commands in Running Containers

```bash
docker exec -it my-nginx sh
```

### View Images

```bash
docker images
```

### Inspect Container Configuration

```bash
docker inspect my-nginx
```

### Monitor Resource Usage

```bash
docker stats
```

### Check Docker Disk Usage

```bash
docker system df
```

---

## Key Learnings

* Containers are isolated processes, not virtual machines.
* Images are blueprints; containers are running instances.
* Docker uses the host kernel.
* Multiple containers can expose the same internal port.
* Host ports must remain unique.
* `docker stop` sends SIGTERM.
* `docker kill` sends SIGKILL.
* Exit code 137 indicates SIGKILL.
* Exit code 143 indicates SIGTERM.
* Members of the `docker` group effectively have root-level capabilities.

---

## Useful Commands Cheat Sheet

```bash
docker run hello-world
docker run -d --name my-nginx -p 8080:80 nginx
docker run -it ubuntu bash

docker ps
docker ps -a
docker images

docker logs my-nginx
docker exec -it my-nginx sh

docker stop my-nginx
docker rm my-nginx

docker inspect my-nginx
docker stats
docker system df
```
