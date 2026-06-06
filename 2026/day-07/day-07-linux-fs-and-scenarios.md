While practicing I notice the terminal for long outputs was simply truncating the history :) Guess I need to make sure to keep recording. Will surely be tracked in next one but for now, here's a gist of what was practiced today..

shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ls -la /bin/ | head
total 119200
drwxr-xr-x   2 root root       28672 Jun  3 16:13 .
drwxr-xr-x  12 root root        4096 Apr 20 18:05 ..
lrwxrwxrwx   1 root root           4 Dec  6 09:38 NF -> col1
lrwxrwxrwx   1 root root           1 Feb 27 18:18 X11 -> .
lrwxrwxrwx   1 root root          28 Mar 30 16:50 [ -> ../lib/cargo/bin/coreutils/[
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-enabled
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-exec
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-features-abi
-rwxr-xr-x   1 root root       25004 Apr  2 02:23 add-apt-repository
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ls -la /bin/ | head -10
total 119200
drwxr-xr-x   2 root root       28672 Jun  3 16:13 .
drwxr-xr-x  12 root root        4096 Apr 20 18:05 ..
lrwxrwxrwx   1 root root           4 Dec  6 09:38 NF -> col1
lrwxrwxrwx   1 root root           1 Feb 27 18:18 X11 -> .
lrwxrwxrwx   1 root root          28 Mar 30 16:50 [ -> ../lib/cargo/bin/coreutils/[
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-enabled
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-exec
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-features-abi
-rwxr-xr-x   1 root root       25004 Apr  2 02:23 add-apt-repository
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ls -la /bin/ | head -20\
> ^C
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ls -la /bin/ | head -20
total 119200
drwxr-xr-x   2 root root       28672 Jun  3 16:13 .
drwxr-xr-x  12 root root        4096 Apr 20 18:05 ..
lrwxrwxrwx   1 root root           4 Dec  6 09:38 NF -> col1
lrwxrwxrwx   1 root root           1 Feb 27 18:18 X11 -> .
lrwxrwxrwx   1 root root          28 Mar 30 16:50 [ -> ../lib/cargo/bin/coreutils/[
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-enabled
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-exec
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-features-abi
-rwxr-xr-x   1 root root       25004 Apr  2 02:23 add-apt-repository
lrwxrwxrwx   1 root root          26 Mar 15 01:33 addr2line -> x86_64-linux-gnu-addr2line
-rwxr-xr-x   1 root root        2322 Apr  9 11:58 apport-bug
-rwxr-xr-x   1 root root       13936 Apr 13 11:51 apport-cli
lrwxrwxrwx   1 root root          10 Apr 13 11:51 apport-collect -> apport-bug
-rwxr-xr-x   1 root root        3798 Apr 13 11:51 apport-unpack
-rwxr-xr-x   1 root root      141616 Jan 28 21:08 appstreamcli
lrwxrwxrwx   1 root root           6 Feb  2 20:49 apropos -> whatis
-rwxr-xr-x   1 root root       23072 Apr  7 09:02 apt
lrwxrwxrwx   1 root root          18 Apr  2 02:23 apt-add-repository -> add-apt-repository
-rwxr-xr-x   1 root root      100904 Apr  7 09:02 apt-cache
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ls -la /bin/ | head -21
total 119200
drwxr-xr-x   2 root root       28672 Jun  3 16:13 .
drwxr-xr-x  12 root root        4096 Apr 20 18:05 ..
lrwxrwxrwx   1 root root           4 Dec  6 09:38 NF -> col1
lrwxrwxrwx   1 root root           1 Feb 27 18:18 X11 -> .
lrwxrwxrwx   1 root root          28 Mar 30 16:50 [ -> ../lib/cargo/bin/coreutils/[
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-enabled
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-exec
-rwxr-xr-x   1 root root       14720 Apr  8 17:26 aa-features-abi
-rwxr-xr-x   1 root root       25004 Apr  2 02:23 add-apt-repository
lrwxrwxrwx   1 root root          26 Mar 15 01:33 addr2line -> x86_64-linux-gnu-addr2line
-rwxr-xr-x   1 root root        2322 Apr  9 11:58 apport-bug
-rwxr-xr-x   1 root root       13936 Apr 13 11:51 apport-cli
lrwxrwxrwx   1 root root          10 Apr 13 11:51 apport-collect -> apport-bug
-rwxr-xr-x   1 root root        3798 Apr 13 11:51 apport-unpack
-rwxr-xr-x   1 root root      141616 Jan 28 21:08 appstreamcli
lrwxrwxrwx   1 root root           6 Feb  2 20:49 apropos -> whatis
-rwxr-xr-x   1 root root       23072 Apr  7 09:02 apt
lrwxrwxrwx   1 root root          18 Apr  2 02:23 apt-add-repository -> add-apt-repository
-rwxr-xr-x   1 root root      100904 Apr  7 09:02 apt-cache
-rwxr-xr-x   1 root root       27176 Apr  7 09:02 apt-cdrom
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ which ls
/usr/bin/ls
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ which cat
/usr/bin/cat
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ which systemctl
/usr/bin/systemctl
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ systemctl list-units --type=service
  UNIT                                     LOAD   ACTIVE     SUB          DESCRIPTION                                   
  chrony.service                           loaded active     running      chrony, an NTP client/server
  console-setup.service                    loaded active     exited       Set console font and keymap
  cron.service                             loaded active     running      Regular background program processing daemon
  dbus.service                             loaded active     running      D-Bus System Message Bus
  getty@tty1.service                       loaded active     running      Getty on tty1
  keyboard-setup.service                   loaded active     exited       Set the console keyboard layout
  kmod-static-nodes.service                loaded active     exited       Create List of Static Device Nodes
  ldconfig.service                         loaded active     exited       Rebuild Dynamic Linker Cache
  netplan-configure.service                loaded active     exited       Netplan Backend Configuration
  networkd-dispatcher.service              loaded active     running      Dispatcher daemon for systemd-networkd
  rsyslog.service                          loaded active     running      System Logging Service
  setvtrgb.service                         loaded active     exited       Set console scheme
  snapd.seeded.service                     loaded active     exited       Wait until snapd is fully seeded
  systemd-binfmt.service                   loaded active     exited       Set Up Additional Binary Formats
  systemd-journal-catalog-update.service   loaded active     exited       Rebuild Journal Catalog
  systemd-journal-flush.service            loaded active     exited       Flush Journal to Persistent Storage
  systemd-journald.service                 loaded active     running      Journal Service
  systemd-logind.service                   loaded active     running      User Login Management
  systemd-modules-load.service             loaded active     exited       Load Kernel Modules
  systemd-remount-fs.service               loaded active     exited       Remount Root and Kernel File Systems
  systemd-resolved.service                 loaded active     running      Network Name Resolution
  systemd-sysctl.service                   loaded active     exited       Apply Kernel Variables
  systemd-sysusers.service                 loaded active     exited       Create System Users
  systemd-tmpfiles-setup-dev-early.service loaded active     exited       Create Static Device Nodes in /dev gracefully
  systemd-tmpfiles-setup-dev.service       loaded active     exited       Create Static Device Nodes in /dev
  systemd-tmpfiles-setup.service           loaded active     exited       Create System Files and Directories
  systemd-udev-load-credentials.service    loaded active     exited       Load udev Rules from Credentials
  systemd-udev-trigger.service             loaded active     exited       Coldplug All udev Devices
  systemd-udevd.service                    loaded active     running      Rule-based Manager for Device Events and Files
  systemd-update-done.service              loaded active     exited       Update is Completed
  systemd-user-sessions.service            loaded active     exited       Permit User Sessions
  unattended-upgrades.service              loaded active     running      Unattended Upgrades Shutdown
  user-runtime-dir@1000.service            loaded active     exited       User Runtime Directory /run/user/1000
  user@1000.service                        loaded active     running      User Manager for UID 1000
● wsl-pro.service                          loaded activating auto-restart Bridge to Ubuntu Pro agent on Windows

Legend: LOAD   → Reflects whether the unit definition was properly loaded.
        ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
        SUB    → The low-level unit activation state, values depend on unit type.

35 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ systemctl is-enabled console-setup.service
enabled
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ journalctl -u console-setup.service -n 20
Jun 06 06:00:19 Shubham-Laptop systemd[1]: Starting console-setup.service - Set console font and keymap...
Jun 06 06:00:19 Shubham-Laptop systemd[1]: Finished console-setup.service - Set console font and keymap.
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ journalctl -u console-setup.service --since "1 hour ago"
-- No entries --
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ps =aux --sort=-%cpu| head -10
error: garbage option

Usage:
 ps [options]

 Try 'ps --help <simple|list|output|threads|misc|all>'
  or 'ps --help <s|l|o|t|m|a>'
 for additional help text.

For more details see ps(1).
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ps aux --sort=-%cpu| head -10
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
shubhs2+    4493  100  0.0   7152  4224 pts/2    R+   17:43   0:00 ps aux --sort=-%cpu
shubhs2+    1884  0.0  0.0   6392  5776 pts/2    Ss   16:06   0:00 -bash
root        1881  0.0  0.0   3192  1252 ?        S    16:06   0:00 /init
root         104  0.0  0.1  35092 12100 ?        Ss   08:15   0:02 /usr/lib/systemd/systemd-udevd
root        4445  0.0  0.1 1792292 14692 ?       Ssl  17:35   0:00 /usr/libexec/wsl-pro-service
root           1  0.0  0.1  24704 15452 ?        Ss   08:15   0:01 /sbin/init
root          58  0.0  0.2  50372 16792 ?        S<s  08:15   0:00 /usr/lib/systemd/systemd-journald
shubhs2+    2435  0.0  0.1  22404 12604 pts/2    Tl   16:19   0:00 vi .git/config
shubhs2+     430  0.0  0.0   8296  6680 pts/0    Ss+  08:15   0:00 -bash
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ps aux --sort=%cpu| head -10
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
_chrony      243  0.0  0.0  12076  2404 ?        S    08:15   0:00 /usr/sbin/chronyd -n -F 1 -x
root         249  0.0  0.0   5484  2696 tty1     Ss+  08:15   0:00 /usr/sbin/agetty --noreset --noclear --issue-file=/etc/issue:/etc/issue.d:/run/issue.d:/usr/lib/issue.d - linux
root         428  0.0  0.0   3176  1104 ?        Ss   08:15   0:00 /init
shubhs2+     598  0.0  0.0  22892  4060 ?        S    08:16   0:00 (sd-pam)
root         712  0.0  0.0   8628  5460 ?        Ss   08:16   0:00 login -- shubhs248
root        1880  0.0  0.0   3176  1112 ?        Ss   16:06   0:00 /init
shubhs2+    4504  0.0  0.0   7152  4240 pts/2    R+   17:43   0:00 ps aux --sort=%cpu
shubhs2+    4505  0.0  0.0  16296  7520 pts/2    S+   17:43   0:00 head -10
root           8  0.0  0.0   3204  2140 hvc0     Sl+  08:15   0:00 plan9 --control-socket 7 --log-level 4 --server-fd 8 --pipe-fd 10 --log-truncate
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ps aux --sort=-%cpu| head -10
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
shubhs2+    1884  0.0  0.0   6392  5776 pts/2    Ss   16:06   0:00 -bash
root        1881  0.0  0.0   3192  1252 ?        S    16:06   0:00 /init
root         104  0.0  0.1  35092 12100 ?        Ss   08:15   0:02 /usr/lib/systemd/systemd-udevd
root        4445  0.0  0.1 1792292 14692 ?       Ssl  17:35   0:00 /usr/libexec/wsl-pro-service
root           1  0.0  0.1  24704 15452 ?        Ss   08:15   0:01 /sbin/init
root          58  0.0  0.2  50372 16792 ?        S<s  08:15   0:00 /usr/lib/systemd/systemd-journald
shubhs2+    2435  0.0  0.1  22404 12604 pts/2    Tl   16:19   0:00 vi .git/config
shubhs2+     430  0.0  0.0   8296  6680 pts/0    Ss+  08:15   0:00 -bash
_chrony      238  0.0  0.1  24500 11716 ?        S    08:15   0:00 /usr/sbin/chronyd -n -F 1 -x
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ps -fp 1884
UID          PID    PPID  C STIME TTY          TIME CMD
shubhs2+    1884    1881  0 16:06 pts/2    00:00:00 -bash
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ touch backup.sh
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ echo "#!/bin/bash" > backup.sh
-bash: !/bin/bash: event not found
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ echo '#!/bin/bash' > backup.sh
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ echo 'echo "BAckup Completed"' >> backup.sh 
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ cat backup.sh 
#!/bin/bash
echo "BAckup Completed"
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ./backup.sh 
BAckup Completed
shubhs248@Shubham-Laptop:/mnt/c/Users/shubh/OneDrive/Documents/GitHub/90DaysOfDevOps/2026/day-07$ ls -la
total 8
drwxrwxrwx 1 root root 4096 Jun  6 17:47 .
drwxrwxrwx 1 root root 4096 Jun  6 15:59 ..
-rwxrwxrwx 1 root root 6273 Jun  6 15:59 README.md
-rwxrwxrwx 1 root root   36 Jun  6 17:49 backup.sh
-rwxrwxrwx 1 root root    0 Jun  6 17:12 day-07-linux-fs-and-scenarios.md
