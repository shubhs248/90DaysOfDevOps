# Day 08 – Cloud Deployment: Installing & Configuring Nginx

**Date:** June 6, 2026  
**System:** WSL (Ubuntu on Windows Subsystem Linux)

## Overview

This practice session covers cloud deployment fundamentals using Nginx:
- Package management with `apt` (Ubuntu package manager)
- Web server installation and configuration
- Service management with `systemctl`
- Verifying service status and startup configuration
- Network port analysis with `ss` command
- Testing web server with `curl`
- Log analysis for troubleshooting
- Understanding the complete deployment workflow

---

## 1. System Package Management

### 1.1 Updating Package Lists

**Command:** `sudo apt update`

**What it Does:**
```
Get:1 http://security.ubuntu.com/ubuntu resolute-security InRelease [137 kB]
Get:2 http://archive.ubuntu.com/ubuntu resolute InRelease [136 kB]
Get:3 http://security.ubuntu.com/ubuntu resolute-security/main amd64 Packages [193 kB]
... (multiple package indices downloaded)
Fetched 32.2 MB in 27s (1203 kB/s)
32 packages can be upgraded. Run 'apt list --upgradable' to see them.
```

**Key Points:**
- Downloads latest package metadata from Ubuntu repositories
- Does NOT install or upgrade packages
- Takes ~27 seconds in this environment
- Downloaded 32.2 MB of package information
- 32 packages available for upgrade

**Analogy:**
Think of it like checking a restaurant menu - you're just reading what's available, not ordering yet.

---

### 1.2 Installing Nginx Web Server

**Command:** `sudo apt install nginx -y`

**Installation Process:**
```
Installing:
  nginx
Installing dependencies:
  nginx-common

Suggested packages:
  fcgiwrap  nginx-doc  ssl-cert

Summary:
  Upgrading: 0, Installing: 2, Removing: 0, Not Upgrading: 32
  Download size: 653 kB
  Space needed: 1853 kB / 1025 GB available
```

**What's Being Installed:**
| Package | Size | Purpose |
|---------|------|---------|
| nginx | 617 KB | Main web server binary |
| nginx-common | 36.9 KB | Configuration files and assets |
| **Total** | **653 KB** | Complete Nginx package |

**Installation Flags:**
- `sudo` = Run with administrator privileges
- `-y` = Automatically answer "yes" to prompts (non-interactive)

**Post-Installation Actions:**
```
Created symlink '/etc/systemd/system/multi-user.target.wants/nginx.service' 
  → '/usr/lib/systemd/system/nginx.service'
```

**Meaning:** Nginx is configured to start automatically on system boot

---

## 2. Service Management with systemctl

### 2.1 Checking Service Auto-Start Status

**Command:** `systemctl is-enabled nginx`

**Output:** `enabled`

**Interpretation:**
- ✅ Nginx is configured to start automatically on boot
- Service will restart if system reboots

**Service Status Options:**
| Status | Meaning |
|--------|---------|
| enabled | Starts automatically on boot |
| disabled | Must be manually started |
| static | Cannot be enabled/disabled (dependency only) |
| masked | Explicitly prevented from starting |

---

### 2.2 Detailed Service Status

**Command:** `systemctl status nginx`

**Output:**
```
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Sat 2026-06-06 18:21:14 UTC; 31s ago
  Invocation: b8d03842fe9d4deba612d4bce8605d3c
        Docs: man:nginx(8)
     Process: 5658 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
     Process: 5660 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Main PID: 5702 (nginx)
       Tasks: 17 (limit: 9427)
      Memory: 13M (peak: 34M)
         CPU: 119ms
      CGroup: /system.slice/nginx.service
              ├─5702 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
              ├─5704 "nginx: worker process"
              ├─5705 "nginx: worker process"
              ├─5706 "nginx: worker process"
              ├─5707 "nginx: worker process"
              ├─5708 "nginx: worker process"
              ├─5709 "nginx: worker process"
              ├─5710 "nginx: worker process"
              ├─5711 "nginx: worker process"
              ├─5712 "nginx: worker process"
              ├─5713 "nginx: worker process"
              ├─5714 "nginx: worker process"
              ├─5715 "nginx: worker process"
```

**Breakdown of Status Information:**

| Component | Details | Meaning |
|-----------|---------|---------|
| **Status** | active (running) | Service is operational |
| **Loaded** | enabled, preset: enabled | Will auto-start on boot |
| **Start Time** | 18:21:14 UTC | When service started |
| **Uptime** | 31s ago | Running for 31 seconds |
| **Main PID** | 5702 | Master process ID |
| **Memory** | 13M (peak: 34M) | Current and peak memory usage |
| **CPU** | 119ms | Total CPU time consumed |
| **Worker Processes** | 11 total | Each handles concurrent connections |

**Process Architecture:**
```
nginx: master process (PID 5702)
  ├─ nginx: worker process 1 (PID 5704)
  ├─ nginx: worker process 2 (PID 5705)
  ├─ nginx: worker process 3 (PID 5706)
  ├─ nginx: worker process 4 (PID 5707)
  ├─ nginx: worker process 5 (PID 5708)
  ├─ nginx: worker process 6 (PID 5709)
  ├─ nginx: worker process 7 (PID 5710)
  ├─ nginx: worker process 8 (PID 5711)
  └─ ... (more worker processes)
```

**Why Multiple Workers?**
- Each worker handles independent client connections
- Parallelization = high concurrency support
- If one worker crashes, others continue serving

---

## 3. Version and Binary Verification

### 3.1 Checking Installed Version

**Command:** `sudo nginx -v`

**Output:** `nginx version: nginx/1.28.3 (Ubuntu)`

**Information:**
- Version: 1.28.3
- Distribution: Ubuntu package
- Critical for: Vulnerability tracking and compatibility

---

## 4. Network Port Analysis

### 4.1 Checking Open Ports and Connections

**Command:** `sudo ss -tulpn | grep 80`

**Output:**
```
tcp   LISTEN 0      511           0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=5719,fd=5),...)
tcp   LISTEN 0      511              [::]:80           [::]:*    users:(("nginx",pid=5719,fd=6),...)
```

**Command Breakdown:**
- `ss` = Socket statistics (modern replacement for netstat)
- `-t` = TCP sockets only
- `-u` = UDP sockets only
- `-l` = Listening sockets
- `-p` = Show process information
- `-n` = Numeric addresses (don't resolve to hostnames)

**Output Analysis:**

| Field | Value | Meaning |
|-------|-------|---------|
| Protocol | tcp | TCP connection protocol |
| State | LISTEN | Actively listening for connections |
| Local Address | 0.0.0.0:80 / [::]:80 | Listening on all IPv4 and IPv6 interfaces, port 80 |
| Process | nginx (pid=5719) | Nginx process handling this port |

**Key Finding:**
✅ Nginx is successfully listening on port 80 (HTTP port)  
✅ Both IPv4 and IPv6 connections supported  
✅ Multiple processes shown (worker distribution)

---

## 5. Web Server Testing

### 5.1 Testing with curl - Full Response

**Command:** `curl localhost`

**Output:**
```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

**Result:** ✅ Web server is responding with default page

---

### 5.2 Testing with curl - Headers Only

**Command:** `curl -I localhost`

**Output:**
```
HTTP/1.1 200 OK
Server: nginx/1.28.3 (Ubuntu)
Date: Sat, 06 Jun 2026 18:24:21 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Sat, 06 Jun 2026 18:21:14 GMT
Connection: keep-alive
ETag: "6a24651a-267"
Accept-Ranges: bytes
```

**Header Breakdown:**

| Header | Value | Meaning |
|--------|-------|---------|
| HTTP Status | 200 OK | Request successful |
| Server | nginx/1.28.3 | Web server version |
| Content-Type | text/html | Response is HTML |
| Content-Length | 615 bytes | Page size |
| ETag | Hash identifier | Used for cache validation |
| Connection | keep-alive | Persistent connections enabled |

**What the `-I` Flag Does:**
- `-I` = Fetch headers only (no body)
- Useful for quick diagnostics
- Saves bandwidth
- Faster than full page download

---

## 6. Log Analysis

### 6.1 Access Log Inspection

**Command:** `sudo tail -20 /var/log/nginx/access.log`

**Output:**
```
::1 - - [06/Jun/2026:18:23:57 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/8.18.0"
::1 - - [06/Jun/2026:18:24:21 +0000] "HEAD / HTTP/1.1" 200 0 "-" "curl/8.18.0"
```

**Log Entry Fields:**

| Field | Value | Meaning |
|-------|-------|---------|
| Client IP | ::1 | IPv6 localhost address |
| Remote User | - | No authentication (dash = none) |
| Timestamp | 06/Jun/2026:18:23:57 | Request time |
| Request Method | GET / HEAD | HTTP method used |
| HTTP Version | HTTP/1.1 | Protocol version |
| Status Code | 200 | Success response |
| Response Size | 615 / 0 | Bytes sent (0 for HEAD) |
| Referrer | - | No referring page |
| User-Agent | curl/8.18.0 | Client software |

**Insights:**
- Two requests recorded (GET and HEAD)
- Both from localhost (::1 IPv6)
- Both returned 200 OK status
- GET request returned 615 bytes (HTML page)
- HEAD request returned 0 bytes (headers only)

---

### 6.2 Error Log Inspection

**Command:** `sudo tail -20 /var/log/nginx/error.log`

**Output:**
```
2026/06/06 18:21:14 [notice] 5702#5702: using inherited sockets from "5;6;"
```

**Interpretation:**
- ✅ [notice] = Informational message (not an error)
- Process 5702 inherited sockets 5 and 6
- This is normal during startup
- No actual errors occurred

**Log Severity Levels:**
| Level | Severity | Typical Causes |
|-------|----------|----------------|
| debug | Low | Verbose information for debugging |
| info | Low | General informational messages |
| notice | Low | Normal but significant conditions |
| warn | Medium | Warning conditions - review needed |
| error | High | Error conditions - check immediately |
| crit | Critical | Critical conditions - immediate action required |
| alert | Critical | Alert conditions - system may be failing |
| emerg | Critical | Emergency - system is unusable |

---

## 7. Deployment Workflow Summary

```mermaid
1. Update package lists
   ↓
2. Install Nginx package
   ↓
3. Verify service is enabled
   ↓
4. Check service status
   ↓
5. Verify port is listening
   ↓
6. Test with curl
   ↓
7. Check access logs
   ↓
8. Review error logs
   ↓
✅ Deployment Complete!
```

---

## 8. Common Nginx Operations

| Operation | Command | Purpose |
|-----------|---------|---------|
| Start service | `sudo systemctl start nginx` | Start Nginx if not running |
| Stop service | `sudo systemctl stop nginx` | Gracefully stop Nginx |
| Restart service | `sudo systemctl restart nginx` | Stop and start |
| Reload config | `sudo systemctl reload nginx` | Reload without dropping connections |
| Enable on boot | `sudo systemctl enable nginx` | Auto-start on system reboot |
| Disable on boot | `sudo systemctl disable nginx` | Don't auto-start |
| View status | `sudo systemctl status nginx` | Show detailed status |
| Test config | `sudo nginx -t` | Validate configuration file |
| View version | `sudo nginx -v` | Show installed version |

---

## 9. Why Cloud Deployment Matters for DevOps

✅ **Automation:** Deploy applications consistently across environments  
✅ **Scalability:** Add more instances to handle traffic  
✅ **Reliability:** Ensure services are always running  
✅ **Monitoring:** Track service health and performance  
✅ **Troubleshooting:** Quick diagnosis using logs and tools  
✅ **Updates:** Deploy new versions with minimal downtime  

---

## 10. Troubleshooting Guide

| Problem | Diagnosis | Solution |
|---------|-----------|----------|
| Port 80 in use | `sudo ss -tulpn \| grep 80` | Stop conflicting service |
| Nginx won't start | `sudo nginx -t` | Check configuration syntax |
| Connection refused | `sudo systemctl status nginx` | Ensure service is running |
| Wrong content | Check `/etc/nginx/nginx.conf` | Update server configuration |
| High memory usage | `top` or `ps aux` | Review worker process count |
| Slow response | `curl -w "@curl-format.txt"` | Check response times |

---

## 11. Next Steps for Production Deployment

```bash
# Enable HTTPS with SSL certificate
sudo apt install certbot python3-certbot-nginx -y

# Configure custom site configuration
sudo nano /etc/nginx/sites-available/mysite.conf

# Enable site configuration
sudo ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/

# Reload configuration
sudo systemctl reload nginx

# Monitor logs in real-time
sudo tail -f /var/log/nginx/access.log /var/log/nginx/error.log
```

---

## 12. Resources for Further Learning

- `man nginx` - Nginx manual
- `man systemctl` - System service management
- `man ss` - Socket statistics
- `man curl` - Client URL tool
- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [Ubuntu Nginx Guide](https://ubuntu.com/tutorials/install-and-configure-nginx)

---

**Next Steps:**  
- Configure custom Nginx virtual hosts
- Set up SSL/TLS certificates with Certbot
- Implement load balancing across multiple servers
- Create monitoring and alerting for Nginx service
- Practice deploying applications behind Nginx
