# Day 14 – Networking Fundamentals and Hands-on Checks

## Task

Today's goal is to **understand the fundamentals of networking and perform hands-on checks on your system**.

You will:
- Understand basic networking concepts (IP addresses, hostnames, interfaces)
- Learn essential networking commands for DevOps troubleshooting
- Practice checking network connectivity, DNS resolution, and open ports
- Verify that your system can communicate with external services

---

## Expected Output

By the end of today, you should have:

1. A clear understanding of **what happens when you ping a domain**
2. Knowledge of **how to check open ports and services**
3. Ability to **troubleshoot network issues** on any Linux system
4. Documented results of running all the commands in this challenge
5. Proof of work in your fork of this repository

---

## Core Networking Concepts

### 1. **Hostname and IP Address**

Every machine on a network has:
- **Hostname**: A human-readable name for the machine
- **IP Address**: A numeric address that uniquely identifies the machine on the network

```bash
hostname            # Shows the hostname
hostname -I         # Shows the IP address(es)
hostnamectl         # Detailed hostname and system info
```

### 2. **Network Interfaces**

A network interface is a virtual or physical point of connection to a network.

```bash
ifconfig            # Shows network interface configuration (requires net-tools)
ip a                # Modern way to show IP addresses
ip addr show        # Detailed address information
```

### 3. **DNS (Domain Name System)**

DNS translates human-readable domain names (like google.com) into IP addresses.

```bash
dig google.com      # Detailed DNS lookup
nslookup google.com # Simple DNS lookup
```

### 4. **Connectivity and Routing**

- **Ping**: Tests if a host is reachable
- **Traceroute**: Shows the path packets take to reach a destination
- **Curl/wget**: Downloads content from URLs

```bash
ping -c 4 google.com      # Send 4 ICMP packets
traceroute google.com     # Trace the route to google.com
tracepath google.com      # Similar to traceroute (no sudo required)
curl -I https://google.com # Get HTTP headers
```

### 5. **Ports and Services**

- **Port**: A logical endpoint for network communication
- **Common ports**: 22 (SSH), 80 (HTTP), 443 (HTTPS), 3306 (MySQL), 5432 (PostgreSQL), etc.

```bash
ss -tulnp           # Show all listening sockets (modern way)
netstat -an         # Show all connections (older way)
nc -zv localhost 22 # Check if port 22 is open on localhost
```

---

## Hands-On Tasks

### Task 1: Check Your Hostname and IP Address

```bash
# Get your hostname
hostname

# Get your IP address
hostname -I

# Get detailed system info including hostname
hostnamectl
```

**Expected Output:**
- Your system's hostname (e.g., `ip-172-31-5-116`)
- Your IP address(es) (e.g., `172.31.5.116`)
- OS version, kernel, and hardware details
- Virtualization type (important for cloud environments)

**Example from Practice:**
```
ubuntu@ip-172-31-5-116:~$ hostname
ip-172-31-5-116

ubuntu@ip-172-31-5-116:~$ hostname -I
172.31.5.116

ubuntu@ip-172-31-5-116:~$ hostnamectl
 Static hostname: ip-172-31-5-116
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: ec24e1cee93216b8f51e32071fca10a4
Operating System: Ubuntu 26.04 LTS
          Kernel: Linux 7.0.0-1006-aws
    Architecture: x86-64
```

---

### Task 2: Explore Your Network Interfaces

First, install `net-tools` if not present:

```bash
sudo apt install net-tools -y
```

Then check your interfaces:

```bash
# Traditional method
ifconfig

# Modern method (recommended)
ip a
ip addr show
```

**What to look for:**
- **lo (Loopback)**: Always 127.0.0.1 — used for local communication
- **eth0, en0, enX0, etc.**: Your primary network interface
- **inet**: IPv4 address with CIDR notation
- **inet6**: IPv6 address
- **MAC address (ether)**: Physical address of the interface
- **MTU**: Maximum Transmission Unit (usually 1500 bytes)
- **RX/TX packets**: Received/Transmitted packets and bytes

**Example from Practice:**
```
$ ifconfig
enX0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 172.31.5.116  netmask 255.255.240.0  broadcast 172.31.15.255
        inet6 fe80::868:7ff:fe27:5d:e7  prefixlen 64  scopeid 0x20<link>
        ether 0a:68:07:27:5d:e7  txqueuelen 1000  (Ethernet)
        RX packets 35720  bytes 47556598 (47.5 MB)
        TX packets 4693  bytes 487282 (487.2 KB)

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        RX packets 90  bytes 9360 (9.3 KB)
        TX packets 90  bytes 9360 (9.3 KB)
```

---

### Task 3: Test Connectivity with Ping

```bash
# Ping google.com 4 times
ping -c 4 google.com

# Ping your own loopback
ping -c 4 127.0.0.1
```

**What to observe:**
- Round-trip time (RTT) in milliseconds
- Packet loss percentage (0% is good, >0% means network issues)
- TTL (Time To Live) value

**Interpretation:**
- RTT 10.7ms = Good, low latency
- 0% packet loss = No dropped packets
- TTL decreases as packet travels through hops

**Example from Practice:**
```
$ ping -c 4 google.com
PING google.com (74.125.199.101) 56(84) bytes of data.
64 bytes from ph-in-f101.1e100.net (74.125.199.101): icmp_seq=1 ttl=105 time=10.7 ms
64 bytes from ph-in-f101.1e100.net (74.125.199.101): icmp_seq=2 ttl=107 time=10.8 ms
64 bytes from ph-in-f101.1e100.net (74.125.199.101): icmp_seq=3 ttl=107 time=10.7 ms
64 bytes from ph-in-f101.1e100.net (74.125.199.101): icmp_seq=4 ttl=105 time=10.7 ms

--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 10.652/10.715/10.840/0.073 ms
```

---

### Task 4: Trace the Route to a Server

Install traceroute if not present:

```bash
sudo apt install traceroute -y
```

Then trace the route:

```bash
# Traditional traceroute
traceroute google.com

# Lightweight alternative (no sudo needed)
tracepath google.com
```

**What to observe:**
- Number of hops to reach the destination
- Latency at each hop (in milliseconds)
- Timeouts (indicated by `*` — router doesn't respond)
- IP addresses and sometimes hostnames

**Why it matters for DevOps:**
- Identify bottlenecks in network path
- Detect routing issues
- Measure hop-by-hop latency

**Example from Practice:**
```
$ traceroute google.com
traceroute to google.com (74.125.199.113), 30 hops max, 60 byte packets
 1  242.4.194.67 (242.4.194.67)  6.459 ms 242.16.83.107 (242.16.83.107)  6.342 ms 242.16.82.239 (242.16.82.239)  7.500 ms
 2  * * *
 3  * 99.83.117.223 (99.83.117.223)  6.889 ms *
 4  * * *
 5  142.251.50.242 (142.251.50.242)  8.175 ms 142.251.55.202 (142.251.55.202)  5.969 ms 142.251.241.136 (142.251.241.136)  5.847 ms
 6  192.178.105.64 (192.178.105.64)  7.322 ms 108.170.235.196 (108.170.235.196)  6.995 ms 192.178.105.64 (192.178.105.64)  7.059 ms
 7  142.251.55.131 (142.251.55.131)  11.492 ms  12.534 ms 142.250.231.127 (142.250.231.127)  11.886 ms
...
19  ph-in-f113.1e100.net (74.125.199.113)  12.118 ms * *
```

---

### Task 5: Resolve Domain Names with DNS

First, ensure DNS utilities are installed:

```bash
sudo apt install dnsutils -y  # May already be installed
```

Then query DNS:

```bash
# Detailed DNS query (dig)
dig google.com

# Simple DNS query (nslookup)
nslookup google.com
```

**What to look for:**
- **A record**: IPv4 address (e.g., 142.250.69.174)
- **AAAA record**: IPv6 address
- **Query time**: How long the DNS lookup took (in milliseconds)
- **Server**: Which DNS server responded (usually 127.0.0.53 for local)
- **Status**: NOERROR = success

**Example from Practice:**
```
$ dig google.com
; <<>> DiG 9.20.18-1ubuntu2.1-Ubuntu <<>> google.com
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             136     IN      A       142.250.69.174

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)

$ nslookup google.com
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   google.com
Address: 142.250.69.174
Address: 2607:f8b0:400e:c05::65
Address: 2607:f8b0:400e:c05::8a
Address: 2607:f8b0:400e:c05::8b
Address: 2607:f8b0:400e:c05::64
```

---

### Task 6: Check Open Ports and Listening Services

```bash
# Modern method (recommended)
ss -tulnp

# Legacy method
netstat -an

# Check for services on specific ports
ss -tulnp | grep 80
ss -tulnp | grep 22
```

**Output breakdown:**
- **tcp/udp**: Protocol type
- **LISTEN**: Service is waiting for connections
- **Local Address:Port**: Where the service is listening (0.0.0.0 = all interfaces)
- **Peer Address:Port**: Who can connect (0.0.0.0 = anyone)
- **Process**: Which application is listening

**Example from Practice:**
```
$ ss -tulnp
Netid  State   Recv-Q Send-Q  Local Address:Port  Peer Address:Port  Process
udp    UNCONN  0      0       127.0.0.54:53       0.0.0.0:*
udp    UNCONN  0      0       172.31.5.116%enX0:68 0.0.0.0:*
tcp    LISTEN  0      4096    127.0.0.54:53       0.0.0.0:*
tcp    LISTEN  0      4096    0.0.0.0:22          0.0.0.0:*
tcp    LISTEN  0      4096    0.0.0.0:80          0.0.0.0:*
```

---

### Task 7: Test Specific Ports with Netcat

Install netcat if not present:

```bash
sudo apt install netcat-openbsd -y
```

Test port connectivity:

```bash
# Test if port 22 (SSH) is open
nc -zv localhost 22

# Test if port 80 (HTTP) is open
nc -zv localhost 80

# Test a remote server
nc -zv google.com 443
```

**Output meanings:**
- `succeeded!`: Port is open and accepting connections
- `Connection refused`: Port is closed or no service listening
- `Temporary failure in name resolution`: DNS can't resolve hostname

**Example from Practice:**
```
$ nc -zv localhost 22
Connection to localhost (127.0.0.1) 22 port [tcp/ssh] succeeded!

$ nc -zv localhost 80
Connection to localhost (127.0.0.1) 80 port [tcp/http] succeeded!

$ nc -zv nginx 80
nc: getaddrinfo for host "nginx" port 80: Temporary failure in name resolution
```

---

### Task 8: Test HTTP Connectivity with Curl

```bash
# Get HTTP headers (no body)
curl -I https://google.com

# Get full response
curl https://google.com

# Follow redirects
curl -L https://google.com
```

**What to observe:**
- HTTP response code (200 OK, 301 Moved, 404 Not Found, etc.)
- Response headers (Server, Content-Type, Cache-Control, etc.)
- Content-Security-Policy and other security headers
- Redirects and location changes

**Common HTTP Status Codes:**
- 200: OK (success)
- 301/302: Redirect
- 400: Bad Request
- 403: Forbidden
- 404: Not Found
- 500: Server Error
- 503: Service Unavailable

**Example from Practice:**
```
$ curl -I https://google.com
HTTP/2 301
location: https://www.google.com/
content-type: text/html; charset=UTF-8
content-security-policy-report-only: object-src 'none';base-uri 'self';...
date: Fri, 12 Jun 2026 17:05:35 GMT
expires: Sun, 12 Jul 2026 17:05:35 GMT
cache-control: public, max-age=2592000
server: gws
content-length: 220
x-xss-protection: 0
x-frame-options: SAMEORIGIN
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

---

## Reflection

- Which command gives you the fastest signal when something is broken?

  The fastest, lowest-effort signal is `ping -c 1 <target>` — it immediately tells you whether the host is reachable (L3/L4 level). For a single-machine quick check of local services, `ss -tulnp` (or `nc -zv localhost <port>`) gives an instant view if the service is listening. For application-level problems, `curl -I <url>` provides the fastest signal (HTTP status code).

- What layer (OSI/TCP‑IP) would you inspect next if DNS fails? If HTTP 500 shows up?

  - If DNS fails: start at the Application layer (DNS is an application protocol on UDP/TCP port 53) to confirm the resolver behavior (dig/nslookup). Then move down to Transport (UDP/TCP port 53) and Network (IP routing, default gateway) — i.e., L7 → L4 → L3 (and L2 if link issues are suspected).

  - If HTTP 500 appears: that's an Application layer (L7) error indicating the server encountered an internal problem. Inspect the application and web server logs first, then check upstream dependencies (database, cache) and resource constraints (CPU/memory). If those look fine, verify transport/network (L4/L3) only if requests are being dropped or reset.

- Two follow-up checks you’d run in a real incident.

  1. Reproduce the failing request with `curl -v -w "\nTime: %{time_total}s\n" <url>` to capture request/response headers, status, and timing; concurrently tail the application logs (`journalctl -u <service> -f` or `tail -F /var/log/<app>.log`) to catch stack traces or error messages.

  2. Check service/process and system health: `sudo systemctl status <service>` and `ps aux | grep <process>` to confirm the process is running, then `top`/`htop` and `df -h` to rule out CPU, memory, or disk pressure; also test connectivity to any backend (e.g., `nc -zv db.example.com 3306`) to ensure dependencies are reachable.

---

## Cheat Sheet

| Command | Purpose | Example |
|---------|---------|---------|
| `hostname` | Get hostname | `hostname` |
| `hostname -I` | Get IP address(es) | `hostname -I` |
| `hostnamectl` | Show full host info | `hostnamectl` |
| `ip a` | Show all interfaces | `ip a` |
| `ip addr show` | Detailed address info | `ip addr show` |
| `ifconfig` | Show interface config | `ifconfig` (if net-tools installed) |
| `ping -c 4 HOST` | Test connectivity | `ping -c 4 google.com` |
| `traceroute HOST` | Trace route to host | `traceroute google.com` |
| `tracepath HOST` | Trace route (no sudo) | `tracepath google.com` |
| `dig DOMAIN` | DNS lookup (detailed) | `dig google.com` |
| `nslookup DOMAIN` | DNS lookup (simple) | `nslookup google.com` |
| `ss -tulnp` | Show listening sockets | `ss -tulnp` |
| `netstat -an` | Show all connections | `netstat -an` |
| `nc -zv HOST PORT` | Test port connection | `nc -zv localhost 22` |
| `curl -I URL` | Get HTTP headers | `curl -I https://google.com` |
| `curl -w "Time: %{time_total}s"` | Test with timing | `curl -w "Time: %{time_total}s" https://google.com` |

---

## Common Issues and Fixes

### Issue 1: Command not found (net-tools, dnsutils, etc.)
**Error:** `command not found: ifconfig`

**Solution:**
```bash
sudo apt update
sudo apt install net-tools dnsutils traceroute netcat-openbsd -y
```

### Issue 2: Permission denied when checking ports
**Error:** `Permission denied` when running `ss -tulnp`

**Solution:**
```bash
# Use sudo for privileged commands
sudo ss -tulnp
sudo netstat -an
```

### Issue 3: No internet connectivity
**Error:** `ping google.com` fails

**Check:**
```bash
# Is the interface up?
ip link show

# Is DHCP working?
sudo dhclient <interface>

# Check default gateway
ip route show

# Ping the gateway
ping <gateway-ip>
```

### Issue 4: DNS not resolving
**Error:** `Temporary failure in name resolution`

**Check:**
```bash
# Check /etc/resolv.conf
cat /etc/resolv.conf

# Manually set DNS (temporary)
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf

# Check if systemd-resolved is running
systemctl status systemd-resolved
```

### Issue 5: Connection refused on local port
**Error:** `Connection refused` for `nc -zv localhost 80`

**Solution:**
```bash
# Check what's listening
ss -tulnp | grep 80

# Start the service
sudo systemctl start nginx
```

---

## Submission

1. Fork this `90DaysOfDevOps` repository (if not already done)
2. Navigate to `2026/day-14/`
3. Create a file named `networking-results.md` with:
   - Output of all the commands you ran
   - Your observations and learnings
   - Any issues you faced and how you resolved them
   - Screenshots or command outputs
4. Commit and push your changes

**Example format for networking-results.md:**
```markdown
# Day 14 - Networking Results

## Hostname and IP
- Hostname: ip-172-31-5-116
- IP: 172.31.5.116

## Network Interfaces
- Primary interface: enX0 (172.31.5.116/20)
- Loopback: lo (127.0.0.1/8)

## Connectivity Test
- Ping to google.com: 0% packet loss, avg RTT: 10.715ms
- DNS resolution: Working (127.0.0.53)

## Open Ports
- SSH: Port 22 (LISTEN)
- HTTP: Port 80 (LISTEN via nginx)

## Issues Encountered
- Initially, net-tools wasn't installed → solved with apt install
```

---

## Learn in Public

Share your Day 14 progress on LinkedIn:

- Post about what networking commands you learned today
- Share one networking troubleshooting scenario you practiced
- Mention why networking is important for DevOps

**Example post:**
```
Day 14 of #90DaysOfDevOps completed! 🚀
Today I learned essential networking commands:
- ping, traceroute, dig for connectivity & DNS
- ss, netstat for port management
- curl for HTTP testing

Networking is the backbone of DevOps. Every issue boils down to:
"Can host A talk to host B on port X?" 🔗

#DevOpsKaJosh #TrainWithShubham #Networking
```

Use hashtags:
```
#90DaysOfDevOps
#DevOpsKaJosh
#TrainWithShubham
#Networking
```

---

## Key Takeaways

By the end of today, you should know:

✅ How to check your hostname and IP address  
✅ How to view network interfaces and configurations  
✅ How to test connectivity with ping and traceroute  
✅ How to resolve domain names with DNS  
✅ How to check open ports and listening services  
✅ How to troubleshoot network issues systematically  
✅ Why networking is critical for DevOps engineers  

---

## Resources

- [Linux Networking Commands](https://man7.org/linux/man-pages/man1/ping.1.html)
- [SS (Socket Statistics) Manual](https://man7.org/linux/man-pages/man8/ss.8.html)
- [IP Command Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/using-the-ip-command_configuring-basic-system-settings)
- [DNS Basics](https://www.cloudflare.com/learning/dns/what-is-dns/)
- [Understanding TCP/IP](https://www.ibm.com/cloud/learn/tcp-ip)
- [Netcat (nc) Guide](https://linux.die.net/man/1/nc)
- [Curl Manual](https://curl.se/docs/manual.html)

---

Happy Learning  
**TrainWithShubham**
