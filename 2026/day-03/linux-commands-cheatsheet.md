# Linux Commands Cheat Sheet

## Process Management

```bash
ps aux                          # List all running processes with full details
ps aux | grep <name>            # Find specific process by name
top -b -n 1                     # Show processes with CPU/memory usage (batch mode)
htop                            # Interactive process viewer (better than top)
pgrep <process>                 # Find PID by process name
kill -9 <pid>                   # Force kill process (SIGKILL)
kill -15 <pid>                  # Graceful shutdown (SIGTERM)
killall <process>               # Kill all instances of a process
bg                              # Move process to background
fg                              # Bring process to foreground
jobs                            # List background jobs
wait <pid>                      # Wait for process to finish
systemctl status <service>      # Check service status
systemctl restart <service>     # Restart a service
journalctl -u <service> -n 50   # View last 50 logs of a service
journalctl -f                   # Follow live logs
```

---

## File System

```bash
ls -lah                         # List files with permissions, sizes, hidden files
cd <path>                       # Change directory
pwd                             # Print working directory
mkdir -p <path>                 # Create directory with parent directories
rm -rf <path>                   # Remove directory/files recursively
cp -r <src> <dst>               # Copy files/directories recursively
mv <src> <dst>                  # Move/rename files
chmod 755 <file>                # Change file permissions (rwxr-xr-x)
chown user:group <file>         # Change file owner and group
du -sh <path>                   # Disk usage of directory/file
df -h                           # Disk space of mounted filesystems
find / -name <filename>         # Search for files by name
grep -r "<pattern>" <path>      # Search pattern recursively in files
tar -czf <archive.tar.gz> <dir> # Compress directory to tar.gz
tar -xzf <archive.tar.gz>       # Extract tar.gz archive
cat <file>                      # Display file contents
tail -f <file>                  # Follow file (live tail for logs)
wc -l <file>                    # Count lines in file
```

---

## Networking Troubleshooting

```bash
ping -c 4 <host>                # Test connectivity to host (4 packets)
ip addr show                    # Display all network interfaces and IPs
ip addr add <ip>/<mask> dev eth0 # Add IP address to interface
ip route show                   # Display routing table
netstat -tuln                   # Show open ports and listening services
ss -tuln                        # Modern alternative to netstat (faster)
curl -I <url>                   # Fetch HTTP headers only
curl -X GET <url>               # Make HTTP GET request
dig <domain>                    # DNS lookup (shows all records)
nslookup <domain>               # DNS query (simpler than dig)
traceroute <host>               # Trace network path to host
nc -zv <host> <port>            # Test if port is open (netcat)
iptables -L -n                  # List firewall rules
ufw status                       # Check UFW firewall status
ifconfig                        # Show network interfaces (deprecated, use ip)
hostname -I                     # Show local IP addresses
lsof -i :<port>                 # List process using specific port
ethtool <interface>             # Get interface speed/duplex settings
```

---

## Quick Troubleshooting Scenarios

### Service Not Responding?
```bash
systemctl status <service>              # Check status
journalctl -u <service> -n 100          # View recent logs
lsof -i :<port>                         # See what's using the port
ss -tuln | grep <port>                  # Check if port is listening
```

### High CPU/Memory?
```bash
top -b -n 1 | head -20                  # Show top processes
ps aux --sort=-%cpu | head               # Sort by CPU usage
ps aux --sort=-%mem | head               # Sort by memory usage
kill -9 <pid>                           # Force terminate if needed
```

### Disk Space Issue?
```bash
df -h                                   # Overall disk usage
du -sh /*                               # Size of each top-level directory
du -sh /var/log                         # Check log directory size
find /path -type f -size +100M          # Find large files (>100MB)
```

### Network Connectivity Problem?
```bash
ping 8.8.8.8                            # Test internet connectivity
dig google.com                          # Check DNS resolution
ip route show                           # Verify routing
netstat -tuln | grep LISTEN             # Check listening ports
traceroute 8.8.8.8                      # Trace route to external host
```

---

## Pro Tips
- Use `alias ll='ls -lah'` in your `.bashrc` to save time
- Combine commands with pipes: `ps aux | grep python | grep -v grep`
- Use `&&` to chain commands: `cd /path && ls -la`
- Always use `-h` flag for human-readable output (`du -h`, `df -h`)
- Redirect output: `journalctl -u service > output.log` or append `>>`
- Use `sudo` when needed, but understand what you're running
- `man <command>` is your best friend – use it to learn flags

---

## Command Frequency in Production
**Used Daily:** ps, top, systemctl, journalctl, ls, grep, tail, curl, ping, ss  
**Used Weekly:** chmod, chown, tar, find, dig, traceroute, iptables  
**Used When Needed:** kill, killall, mount, umount, lsof, nc, ethtool


