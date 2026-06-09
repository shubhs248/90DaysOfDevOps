# Day 11 Challenge - File Ownership (chown & chgrp)

## Files & Directories Created

### Task 1 - Understanding Ownership
- No files created (documentation task)
- Identified owner and group columns in `ls -l` output

### Task 2 - Basic chown Operations
- `devops.txt` - Changed owner from `ubuntu` → `tokyo` → `berlin`

### Task 3 - Basic chgrp Operations
- `team-notes.txt` - Changed group from `ubuntu` → `tokyo` → `berlin` → `heist-group`

### Task 4 - Combined Owner & Group Change
- `project-config.yaml` - Owner: `berlin`, Group: `heist-group`
- `app-logs/` (directory) - Owner: `tokyo`, Group: `heist-group`

### Task 5 - Recursive Ownership
```
heist-project/
├── plans/
│   └── strategy.conf
└── vault/
    └── gold.txt
```
- All files owned by `professor:planners`

### Task 6 - Practice Challenge
```
bank-heist/
├── access-codes.txt
├── blueprints.pdf
└── escape-plan.txt
```
- `access-codes.txt` - Owner: `tokyo`, Group: `vault-team`
- `blueprints.pdf` - Owner: `berlin`, Group: `tech-team`
- `escape-plan.txt` - Owner: `nairobi`, Group: `vault-team`

---

## Ownership Changes Summary

| File/Directory | Initial | Final | Command |
|---|---|---|---|
| devops.txt | ubuntu:ubuntu | berlin:ubuntu | `sudo chown berlin devops.txt` |
| team-notes.txt | ubuntu:ubuntu | tokyo:heist-group | `sudo chgrp heist-group team-notes.txt` |
| project-config.yaml | ubuntu:ubuntu | berlin:heist-group | `sudo chown berlin:heist-group project-config.yaml` |
| app-logs/ | ubuntu:ubuntu | tokyo:heist-group | `sudo chown tokyo:heist-group app-logs/` |
| heist-project/ (recursive) | ubuntu:ubuntu | professor:planners | `sudo chown -R professor:planners heist-project/` |
| bank-heist/access-codes.txt | ubuntu:ubuntu | tokyo:vault-team | `sudo chown tokyo:vault-team bank-heist/access-codes.txt` |
| bank-heist/blueprints.pdf | ubuntu:ubuntu | berlin:tech-team | `sudo chown berlin:tech-team bank-heist/blueprints.pdf` |
| bank-heist/escape-plan.txt | ubuntu:ubuntu | nairobi:vault-team | `sudo chown nairobi:vault-team bank-heist/escape-plan.txt` |

---

## Commands Used

### User & Group Creation
```bash
# Create users
sudo useradd tokyo
sudo useradd berlin
sudo useradd nairobi
sudo useradd professor
sudo passwd tokyo
sudo passwd berlin
sudo passwd nairobi

# Create groups
sudo groupadd heist-group
sudo groupadd planners
sudo groupadd vault-team
sudo groupadd tech-team
```

### Ownership Changes
```bash
# Change owner only
sudo chown tokyo devops.txt
sudo chown berlin devops.txt

# Change group only
sudo chgrp tokyo team-notes.txt
sudo chgrp berlin team-notes.txt
sudo chgrp heist-group team-notes.txt

# Change both owner and group (single command)
sudo chown berlin:heist-group project-config.yaml
sudo chown tokyo:heist-group app-logs/

# Recursive ownership change
sudo chown -R professor:planners heist-project/
```

### Permission Changes (chmod)
```bash
# Add execute permission to user
sudo chmod u+x bank-heist/access-codes.txt
sudo chmod u+x bank-heist/blueprints.pdf

# Add execute permission to user and group
sudo chmod ug+x bank-heist/blueprints.pdf
sudo chmod ug+x bank-heist/escape-plan.txt

# Remove execute permission from group
sudo chmod g-x bank-heist/blueprints.pdf
```

### Verification Commands
```bash
# List files with ownership details
ls -l devops.txt
ls -l team-notes.txt
ls -l project-config.yaml
ls -ld app-logs/
ls -lR heist-project/
ls -l bank-heist/

# Find files by owner
find . -user professor
find . -user tokyo
find . -user berlin
find . -user nairobi

# Check user groups
groups professor

# Get group details
getent group heist-group

# View directory structure
tree heist-project/
tree bank-heist/
find bank-heist/
```

---

## Final Ownership State

### devops.txt
```
-rw-rw-r-- 1 berlin ubuntu 0 Jun 9 16:31 devops.txt
```
Owner: `berlin`, Group: `ubuntu`

### team-notes.txt
```
-rw-rw-r-- 1 tokyo heist-group 0 Jun 9 16:33 team-notes.txt
```
Owner: `tokyo`, Group: `heist-group`

### project-config.yaml
```
-rw-rw-r-- 1 berlin heist-group 0 Jun 9 16:36 project-config.yaml
```
Owner: `berlin`, Group: `heist-group`

### app-logs/
```
drwxrwxr-x 2 tokyo heist-group 4096 Jun 9 16:37 app-logs/
```
Owner: `tokyo`, Group: `heist-group`

### heist-project/ (Recursive)
```
heist-project/:
total 8
drwxrwxr-x 2 professor planners 4096 Jun 9 16:39 plans
drwxrwxr-x 2 professor planners 4096 Jun 9 16:38 vault

heist-project/plans:
total 0
-rw-rw-r-- 1 professor planners 0 Jun 9 16:39 strategy.conf

heist-project/vault:
total 0
-rw-rw-r-- 1 professor planners 0 Jun 9 16:38 gold.txt
```
All owned by `professor:planners`

### bank-heist/
```
total 0
-rwxrw-r-- 1 tokyo   vault-team 0 Jun 9 16:42 access-codes.txt
-rwxrw-r-- 1 berlin  tech-team  0 Jun 9 16:42 blueprints.pdf
-rwxrwxr-- 1 nairobi vault-team 0 Jun 9 16:42 escape-plan.txt
```
Mixed ownership as per requirements

---

## Key Learnings

### 1. **File Ownership Components**
Linux file permissions consist of three parts:
- **Owner (User)**: The user who owns the file
- **Group**: A set of users that share certain permissions
- **Others**: Everyone else on the system

The `ls -l` output shows format: `-rw-r--r-- 1 owner group size date filename`

### 2. **chown vs chgrp**
- **chown**: Changes file/directory owner and/or group
  - Change owner only: `sudo chown newowner filename`
  - Change both: `sudo chown owner:group filename`
  - Change group only: `sudo chown :groupname filename`
- **chgrp**: Changes only the group
  - Syntax: `sudo chgrp newgroup filename`

### 3. **Recursive Changes (-R Flag)**
When managing directories and their contents:
- Use `sudo chown -R owner:group directory/` to recursively change all files and subdirectories
- Essential for maintaining consistent permissions across project structures
- Verify with `ls -lR` to see all changes applied

### 4. **User & Group Management**
- Users must exist before being assigned to files (use `sudo useradd username`)
- Groups must exist before being assigned (use `sudo groupadd groupname`)
- Users can be members of multiple groups (use `sudo usermod -aG group username`)
- Verify groups with `groups username` or `getent group groupname`

### 5. **DevOps Context**
- Critical for managing application deployments where different services run as different users
- Essential for CI/CD pipelines where artifacts may need different owner/group permissions
- Important for containerized environments where file permissions affect container functionality
- Key for managing shared directories in team environments

---

## DevOps Relevance

In real DevOps scenarios, file ownership is crucial for:

- **Application Deployments**: Web servers (nginx, apache) run as specific users requiring proper file ownership
- **Shared Team Directories**: Multiple team members accessing logs, configs, and deployment artifacts
- **Container Permissions**: Docker containers often run as specific users requiring host-side permission alignment
- **CI/CD Artifacts**: Build artifacts and logs need appropriate ownership for access by deployment systems
- **Security & Access Control**: Restricting file access based on user/group membership
- **Log Management**: Ensuring logging services can write to log files with proper ownership

---

## Summary

Day 11 covered essential Linux file ownership management through `chown` and `chgrp` commands. By completing these tasks, I:

✅ Created and managed multiple users and groups
✅ Changed file and directory ownership individually and recursively
✅ Combined owner and group changes in single commands
✅ Verified ownership changes using `ls -l` and `find` commands
✅ Practiced real-world DevOps scenarios with meaningful file structures

This foundation is critical for managing permissions in production environments where proper file ownership ensures application functionality, security, and team collaboration.

---

**Challenge Completed**: Day 11 - File Ownership (chown & chgrp) ✅

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
