# Day 14 Challenge – Networking Fundamentals (Submission)

> Hands-on networking checks on an AWS EC2 Ubuntu instance. Notes and command outputs below are taken from the session recorded in `practice.txt`.

---

## Resources / Observed Environment

| Resource | Value |
|---------:|:------|
| Hostname | `ip-172-31-5-116` |
| Primary IP | `172.31.5.116/20` |
| Primary interface | `enX0` (altname: `enx0a6807275de7`) |
| OS | `Ubuntu 26.04 LTS` |
| Kernel | `Linux 7.0.0-1006-aws` |

---

## Commands Run (summary)

- Identity: `hostname`, `hostname -I`, `hostnamectl`
- Interfaces: `ip a`, `ifconfig` (after installing `net-tools`)
- Connectivity: `ping -c 4 google.com`
- Path: `traceroute google.com`, `tracepath google.com` (after installing `traceroute`)
- DNS: `dig google.com`, `nslookup google.com`
- Ports/Services: `ss -tulnp`, `netstat -an`
- Port tests: `nc -zv localhost 22`, `nc -zv localhost 80`, `nc -zv google.com 443`
- HTTP checks: `curl -I https://google.com`

---

## Key Command Outputs (captured)

### Hostname and system info

```bash
$ hostname
ip-172-31-5-116

$ hostname -I
172.31.5.116

$ hostnamectl
 Static hostname: ip-172-31-5-116
 Operating System: Ubuntu 26.04 LTS
 Kernel: Linux 7.0.0-1006-aws
 Architecture: x86-64
```

### Network interfaces (ip / ifconfig)

```bash
$ ip a
2: enX0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001
    inet 172.31.5.116/20 scope global dynamic enX0
    altname enx0a6807275de7

$ ifconfig
enX0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
    inet 172.31.5.116  netmask 255.255.240.0  broadcast 172.31.15.255
    ether 0a:68:07:27:5d:e7

lo: inet 127.0.0.1
```

### Ping (connectivity)

```bash
$ ping -c 4 google.com
4 packets transmitted, 4 received, 0% packet loss
rtt min/avg/max/mdev = 10.652/10.715/10.840/0.073 ms
```

### Traceroute / tracepath (path)

```bash
$ traceroute google.com
 1  242.4.194.67  6.459 ms  6.342 ms  7.500 ms
 2  * * *
 3  * 99.83.117.223  6.889 ms *
 ...
 19 ph-in-f113.1e100.net 12.118 ms * *

$ tracepath google.com
 pmtu 9001
 1: ip-172-31-0-1.us-west-2.compute.internal 0.215ms pmtu 1500
```

### DNS (dig / nslookup)

```bash
$ dig google.com
;; ANSWER SECTION:
google.com. 136 IN A 142.250.69.174
;; Query time: 0 msec
;; SERVER: 127.0.0.53#53

$ nslookup google.com
Server: 127.0.0.53
Address: 127.0.0.53#53
Name: google.com
Address: 142.250.69.174
```

### Listening services (ss)

```bash
$ ss -tulnp
tcp LISTEN 0 4096 0.0.0.0:22
tcp LISTEN 0 4096 0.0.0.0:80
udp UNCONN 0 0 127.0.0.54:53
```

### Netcat (port checks)

```bash
$ nc -zv localhost 22
Connection to localhost (127.0.0.1) 22 port [tcp/ssh] succeeded!

$ nc -zv localhost 80
Connection to localhost (127.0.0.1) 80 port [tcp/http] succeeded!

$ nc -zv nginx 80
nc: getaddrinfo for host "nginx" port 80: Temporary failure in name resolution
```

### HTTP check (curl)

```bash
$ curl -I https://google.com
HTTP/2 301
location: https://www.google.com/
server: gws
```

---

## Observations & Interpretation

- Network connectivity to the public internet was healthy (0% packet loss, ~10 ms RTT to google.com).
- Traceroute shows some hops that do not reply (`*`) — common for intermediate routers, not necessarily a problem.
- DNS resolution worked locally via `127.0.0.53` (systemd-resolved stub resolver).
- SSH (22) and HTTP (80) sockets were listening locally.
- The `nginx` hostname lookup failed (name resolution issue for that alias) — likely a local / container hostname or missing `/etc/hosts` entry.

---

## Reflection (incident-focused answers)

- Which command gives you the fastest signal when something is broken?

  `ping -c 1 <target>` gives the fastest network-level signal (is host reachable?). For service-level quick checks use `ss -tulnp` or `nc -zv <host> <port>`. For application-level checks `curl -I <url>` returns the HTTP status immediately.

- What layer (OSI/TCP‑IP) would you inspect next if DNS fails? If HTTP 500 shows up?

  - DNS fails: start at Application (DNS lookup with `dig`/`nslookup`), then Transport (UDP/TCP on port 53), then Network (routes/gateway), and Link if necessary. (L7 → L4 → L3 → L2)
  - HTTP 500: Application layer (examine app/webserver logs, application health, upstream dependencies like DB) and then check resource or connectivity issues if logs indicate timeouts (L7 → L4/L3 as needed).

- Two follow-up checks you’d run in a real incident

  1. Reproduce failing request with `curl -v --trace-time <url>` while tailing app logs (`journalctl -u <service> -f` or `tail -F /var/log/<app>.log`) to correlate request with errors.
  2. Check process and system health: `sudo systemctl status <service>`, `ps aux | grep <process>`, `top`/`free -m`/`df -h` and test backend connectivity (`nc -zv db.example.com 3306`).

---

## Mistakes, Fixes & Notes

- `ifconfig` and `traceroute` were not installed initially. Fix: `sudo apt install net-tools traceroute dnsutils netcat-openbsd -y`.
- `nc` name resolution error for `nginx` indicates a missing name mapping (check `/etc/hosts` or DNS for that label).

---

## Key Learnings

- Start with the simplest checks: `ping`, `dig`, `ss`/`nc`, `curl` — these quickly narrow the problem domain.
- DNS problems often mask as connectivity issues; verify name resolution before chasing routing or firewall issues.
- Application errors (HTTP 5xx) require logs and backend dependency checks, not just network tests.

---

## Summary

Day 14 completed: performed a full set of networking checks on an EC2 instance, captured outputs for hostname, interfaces, connectivity, path, DNS, listening services, port tests, and HTTP checks. Resolved missing tooling by installing required packages and identified a local name resolution gap for the `nginx` alias.

**Challenge Completed**: Day 14 – Networking Fundamentals ✅

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
