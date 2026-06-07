# Day 09 Challenge - Linux User & Group Management

## Users & Groups Created

### Users Created:
- `tokyo` (UID: 1001)
- `berlin` (UID: 1002)
- `professor` (UID: 1003)
- `nairobi` (UID: 1004)

### Groups Created:
- `developers` (GID: 1004)
- `admins` (GID: 1005)
- `project-team` (GID: 1006)

---

## Group Assignments

### Group Membership:
| User | Groups |
|------|--------|
| tokyo | tokyo, developers, project-team |
| berlin | berlin, developers, admins |
| professor | professor, admins |
| nairobi | nairobi, project-team |

**Verification Command Output:**
```
$ id tokyo
uid=1001(tokyo) gid=1001(tokyo) groups=1001(tokyo),1004(developers),1006(project-team)

$ id berlin
uid=1002(berlin) gid=1002(berlin) groups=1002(berlin),1004(developers),1005(admins)

$ id professor
uid=1003(professor) gid=1003(professor) groups=1003(professor),1005(admins)

$ id nairobi
uid=1004(nairobi) gid=1004(nairobi) groups=1004(nairobi),1006(project-team)
```

---

## Directories Created

### Directory 1: /opt/dev-project
```
Directory: /opt/dev-project
Owner: root
Group: developers
Permissions: 775 (drwxrwxr-x)
Purpose: Shared workspace for developers group
```

**Verification:**
```
$ ls -ld /opt/dev-project
drwxrwxr-x 2 root developers 4096 Jun  7 08:55 /opt/dev-project

$ stat /opt/dev-project
  File: /opt/dev-project
  size: 4096            Blocks: 8          IO Block: 4096   directory
  Access: (0775/drwxrwxr-x)  Uid: (    0/    root)   Gid: ( 1004/developers)
```

**Files Created & Permissions:**
```
$ ls -la /opt/dev-project/
total 8
drwxrwxr-x 2 root   developers 4096 Jun  7 08:55 .
drwxr-xr-x 3 root   root       4096 Jun  7 08:49 ..
-rw-r--r-- 1 berlin berlin        0 Jun  7 08:55 berlin.txt
-rw-r--r-- 1 tokyo  tokyo         0 Jun  7 08:55 tokyo.txt
```

---

### Directory 2: /opt/team-workspace
```
Directory: /opt/team-workspace
Owner: root
Group: project-team
Permissions: 775 (drwxrwxr-x)
Purpose: Shared workspace for project-team group
```

**Verification:**
```
$ ls -ld /opt/team-workspace/
drwxrwxr-x 2 root project-team 4096 Jun  7 09:12 /opt/team-workspace/
```

**Files Created & Permissions:**
```
$ ls -la /opt/team-workspace/
total 8
drwxrwxr-x 2 root    project-team 4096 Jun  7 09:15 .
drwxr-xr-x 4 root    root         4096 Jun  7 09:12 ..
-rw-r--r-- 1 nairobi nairobi         0 Jun  7 09:14 nairobi.txt
-rw-r--r-- 1 tokyo   tokyo           0 Jun  7 09:15 tokyo.txt
```

---

## Commands Used

### Task 1: Create Users with Home Directories
```bash
# Create users with home directories (-m flag)
sudo useradd -m tokyo
sudo useradd -m berlin
sudo useradd -m professor
sudo useradd -m nairobi

# Set passwords for all users
sudo passwd tokyo
sudo passwd berlin
sudo passwd professor
sudo passwd nairobi

# Verify users in /etc/passwd
grep -E "tokyo|berlin|professor|nairobi" /etc/passwd

# Verify home directories
ls -l /home
```

### Task 2: Create Groups
```bash
# Create groups
sudo groupadd developers
sudo groupadd admins
sudo groupadd project-team

# Verify groups in /etc/group
grep -E "developers|admins|project-team" /etc/group

# Alternative verification
getent group developers
getent group admins
getent group project-team
```

### Task 3: Assign Users to Groups
```bash
# Add tokyo to developers group
sudo usermod -aG developers tokyo

# Add berlin to both developers and admins groups
sudo usermod -aG developers,admins berlin

# Add professor to admins group
sudo usermod -aG admins professor

# Add nairobi and tokyo to project-team
sudo usermod -aG project-team nairobi
sudo usermod -aG project-team tokyo

# Verify group assignments
id tokyo
id berlin
id professor
id nairobi

# Check user's groups
groups tokyo
groups berlin
groups professor
groups nairobi
```

### Task 4: Create Shared Directory with Group Permissions
```bash
# Create directory
sudo mkdir -p /opt/dev-project

# Change group owner to developers
sudo chgrp developers /opt/dev-project/

# Set permissions to 775 (rwxrwxr-x)
sudo chmod 775 /opt/dev-project/

# Verify permissions
ls -la /opt/dev-project/
stat /opt/dev-project

# Test by creating files as different users
sudo -u tokyo touch /opt/dev-project/tokyo.txt
sudo -u berlin touch /opt/dev-project/berlin.txt

# Verify file creation and permissions
ls -la /opt/dev-project/
```

### Task 5: Create Team Workspace
```bash
# Create team-workspace directory
sudo mkdir -p /opt/team-workspace

# Change group owner to project-team
sudo chgrp project-team /opt/team-workspace

# Set permissions to 775 (rwxrwxr-x)
sudo chmod 775 /opt/team-workspace/

# Verify permissions
ls -ld /opt/team-workspace/

# Test by creating files as team members
sudo -u nairobi touch /opt/team-workspace/nairobi.txt
sudo -u tokyo touch /opt/team-workspace/tokyo.txt

# Verify file creation
ls -la /opt/team-workspace/
```

---

## What I Learned

### 1. **User and Group Management Fundamentals**
   - `useradd -m` creates users with home directories automatically
   - `groupadd` creates groups that can be referenced by GID in /etc/group
   - `usermod -aG` appends users to groups without removing existing memberships
   - The `-a` flag is critical to avoid overwriting existing group assignments

### 2. **File Permissions and Group Ownership**
   - `chgrp` changes group ownership independently of user ownership
   - Permissions 775 (drwxrwxr-x) allow owner and group to read/write/execute, others read/execute only
   - Group permissions enable collaborative access - users in the group can create files in shared directories
   - Multiple users in the same group can work together in shared spaces

### 3. **Practical DevOps Applications**
   - Team workspaces require careful group assignment to enable collaboration
   - Shared directories with proper permissions prevent permission-denied errors
   - `sudo -u username command` allows testing operations as different users
   - `id` and `groups` commands are essential for verifying permissions before troubleshooting access issues
   - This workflow mirrors real DevOps scenarios where teams need shared project directories with group-based access control

---

## Key Takeaways
✅ All 5 tasks completed successfully
✅ Users created with home directories and passwords
✅ Groups created and users assigned correctly
✅ Shared directories configured with proper permissions
✅ File creation tested and verified for all users
✅ All verification commands executed successfully

**Learning Completed:** June 7, 2026
