# Day 15 Challenge – Networking Concepts: DNS, IP, Subnets & Ports (Submission)

> Concept-focused submission with answers, command outputs, and a small exercise. Followed the Day 15 README tasks and captured outputs from a sample EC2 environment.

---

A record: 142.250.69.174 — TTL: 136 seconds (example output)

Task 2 — IP Addressing
What is an IPv4 address? How is it structured?
An IPv4 address is a 32‑bit number shown as four decimal octets separated by dots (e.g., 192.168.1.10). Each octet is 8 bits; addresses identify network + host.

Public vs Private IPs (one example each)
Public IP: 34.123.45.67 — reachable over the public internet.
Private IP: 10.0.1.50 — used inside private networks, not routable on the public internet.
Private IP ranges
10.0.0.0/8 (10.0.0.0–10.255.255.255)
172.16.0.0/12 (172.16.0.0–172.31.255.255)
192.168.0.0/16 (192.168.0.0–192.168.255.255)
ip addr show — identify private IPs (sample)
bash
$ ip addr show
2: enX0: inet 172.31.5.116/20 scope global enX0
3: eth0: inet 192.168.1.10/24 scope global eth0
Both 172.31.5.116/20 and 192.168.1.10/24 are private addresses.

Task 3 — CIDR & Subnetting
What does /24 mean in 192.168.1.0/24?
/24 is the prefix length: first 24 bits are network, remaining 8 bits are hosts → subnet mask 255.255.255.0.

Usable hosts for given CIDRs
/24: 256 total IPs → 254 usable hosts
/16: 65,536 total IPs → 65,534 usable hosts
/28: 16 total IPs → 14 usable hosts
Why subnet?
Subnetting divides a network for management, reduces broadcast domains, enforces security boundaries, and uses address space efficiently.

Quick table
CIDR	Subnet Mask	Total IPs	Usable Hosts
/24	255.255.255.0	256	254
/16	255.255.0.0	65,536	65,534
/28	255.255.255.240	16	14
Task 4 — Ports: The Doors to Services
What is a port? Why do we need them?
A port is a 16‑bit number that, combined with an IP, identifies an application endpoint on a host. Ports let many services share one IP address (e.g., SSH on 22, HTTP on 80).

Common ports
Port	Service
22	SSH
80	HTTP
443	HTTPS
53	DNS
3306	MySQL/MariaDB
6379	Redis
27017	MongoDB
ss -tulpn — sample mapping
bash
$ ss -tulpn
tcp LISTEN 0 4096 0.0.0.0:22  users:(\"sshd\",pid=1234)
tcp LISTEN 0 4096 0.0.0.0:80  users:(\"nginx\",pid=2345)
From the sample: port 22 → sshd, port 80 → nginx.

Task 5 — Putting It Together (2–3 line answers)
curl http://myapp.com:8080 — what networking concepts are involved?
DNS resolution (myapp.com → IP), TCP handshake to IP:8080, potential NAT/firewall traversal, HTTP application protocol over that port, and server binding on port 8080.

Your app can't reach a database at 10.0.1.50:3306 — what would you check first?
Connectivity: ping 10.0.1.50 and nc -zv 10.0.1.50 3306 to confirm reachability and port. 2) Firewall/security groups (iptables/ufw/Cloud SG) and whether the DB is listening (ss -tulnp | grep 3306) and accepting remote connections.
Command outputs to include
dig google.com — A record and TTL (see Task 1)
ss -tulpn — listening ports (see Task 4)
(When you submit, replace sample outputs with your actual outputs.)

What I learned (3 key points)
DNS is the critical first step; if it fails, subsequent network checks are pointless until resolved.
CIDR/subnetting is essential for address planning and host capacity.
Ports/services mapping (ss/nc) quickly shows whether a service is reachable before diving into application logs.
Submission notes
Add day-15-networking-concepts.md to 2026/day-15/ with your real dig and ss outputs. This file is a ready-to-use Day‑style submission matching the pattern of Days 13–14.

Challenge Completed (template): Day 15 – Networking Concepts ✅

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
