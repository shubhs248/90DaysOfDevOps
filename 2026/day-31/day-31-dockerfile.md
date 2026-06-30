# Day 31 - Dockerfile: Build Your Own Images 🐳

## Objective

Today's goal was to understand how Docker images are built using Dockerfiles and learn the difference between build-time and run-time instructions.

---

# Task 1: My First Dockerfile

### Dockerfile

```dockerfile
FROM ubuntu:latest

WORKDIR /my-first-image

RUN apt update && \
    apt install -y curl && \
    apt clean

CMD ["echo", "Hello from my custom image!"]
```

### Build

```bash
docker build -t my-ubuntu:v1 .
```

### Run

```bash
docker run my-ubuntu:v1
```

### Output

```text
Hello from my custom image!
```

### Key Learnings

- `FROM` defines the base image.
- `RUN` executes commands during build time.
- `CMD` executes when a container starts.
- `WORKDIR` changes the default working directory.
- Combining commands with `&&` creates fewer layers and smaller images.

---

# Task 2: Dockerfile Instructions

### Dockerfile

```dockerfile
FROM ubuntu

WORKDIR /app

COPY message.txt .

RUN touch hello.txt

EXPOSE 8080

CMD ["bash"]
```

### Verification

```bash
docker build -t dockerfile-demo:v1 .
docker run -it dockerfile-demo:v1
```

### Observations

- `COPY message.txt .` copied the file to `/app/message.txt`.
- `RUN touch hello.txt` created `/app/hello.txt`.
- `EXPOSE 8080` only documents the application port.
- Actual port publishing still requires:

```bash
docker run -p 8080:8080 image-name
```

---

# Task 3: CMD vs ENTRYPOINT

## CMD Example

```dockerfile
CMD ["echo", "hello"]
```

```bash
docker run my-image
```

Output:

```text
hello
```

```bash
docker run my-image bash
```

The default CMD gets completely replaced.

---

## ENTRYPOINT Example

```dockerfile
ENTRYPOINT ["echo"]
```

```bash
docker run my-image hello world
```

Output:

```text
hello world
```

Arguments are appended to the fixed executable.

---

## Combined Example

```dockerfile
ENTRYPOINT ["echo", "Hello"]
CMD ["World"]
```

Default:

```bash
docker run my-image
```

Output:

```text
Hello World
```

Override:

```bash
docker run my-image DevOps
```

Output:

```text
Hello DevOps
```

### Key Takeaway

- **CMD = default command or arguments**
- **ENTRYPOINT = fixed executable**

Production example:

```dockerfile
ENTRYPOINT ["java", "-jar", "payment-service.jar"]
CMD ["--server.port=8080"]
```

---

# Task 4: Build a Static Website

## index.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>90 Days of DevOps</title>
</head>
<body>
    <h1>Day 31 - Dockerfiles</h1>
    <p>Building and shipping custom container images.</p>
    <p>- Shubham Sharma</p>
</body>
</html>
```

---

## Dockerfile

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/

EXPOSE 80
```

---

## Build

```bash
docker build -t my-website:v1 .
```

---

## Run

```bash
docker run -d \
  --name my-website \
  -p 8082:80 \
  my-website:v1
```

---

## Verification

```bash
curl http://localhost:8082
```

Output:

```html
<h1>Day 31 - Dockerfiles</h1>
<p>Building and shipping custom container images.</p>
```

---

# Task 5: .dockerignore

## .dockerignore

```dockerignore
node_modules
.git
.env
*.md
```

### Benefits

- Faster builds
- Smaller build context
- Better layer caching
- Prevents secret leakage
- Improves CI/CD performance

---

# Task 6: Build Optimization

## Bad Practice

```dockerfile
COPY . .

RUN pip install -r requirements.txt
```

Any file change invalidates dependency installation.

---

## Better Practice

```dockerfile
COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .
```

### Benefits

- Dependency layers remain cached.
- Faster Jenkins and GitHub Actions pipelines.
- Reduced build times.
- Lower infrastructure costs.

---

# Important Concepts Learned

## Docker Build Context

```bash
docker build -t my-app .
```

`.` represents the current directory and all files available during image creation.

---

## Build-Time vs Run-Time

### Build Time

- FROM
- RUN
- COPY
- WORKDIR
- EXPOSE
- ENV
- LABEL

### Run Time

- CMD
- ENTRYPOINT

---

# Production Takeaways

- Prefer minimal base images like Alpine.
- Use `.dockerignore` aggressively.
- Keep expensive operations early in Dockerfiles.
- Place frequently changing files near the bottom.
- Use CMD for defaults and ENTRYPOINT for fixed executables.
- Treat Dockerfiles as Infrastructure as Code (IaC).

---

# Day 31 Summary

Today I moved from consuming container images to building and packaging my own applications.

Understanding Dockerfiles, build caching, image layering, and runtime behavior forms the foundation for efficient CI/CD pipelines, Kubernetes deployments, and production-grade container platforms.
