# Day 10 Challenge - File Permissions & File Operations

## Files Created

1. **devops.txt** - Contains "Devops Practice"
2. **notes.txt** - Contains multi-line content ("Line 1", "Line 2")
3. **script.sh** - Executable bash script with content:
   ```bash
   #!/bin/bash
   echo "Hello day-10 of Devops practice"
   ```
4. **script1.sh** - Interactive bash script that displays user info and current date
5. **project/** - Directory for file organization

---

## Permission Changes - Before & After

### File: devops.txt
| Aspect | Before | After | Command |
|--------|--------|-------|---------|
| Permissions | `-rw-rw-r--` (664) | `-r--r--r--` (444) | `chmod a-w devops.txt` |
| Owner | ubuntu | ubuntu | - |
| Group | ubuntu | ubuntu | - |
| **Effect** | Read & Write allowed | Read-only for all | Removed write permission from all |

### File: notes.txt
| Aspect | Before | After | Command |
|--------|--------|-------|---------|
| Permissions | `-rw-rw-r--` (664) | `-rw-r-----` (640) | `chmod 640 notes.txt` |
| Owner | ubuntu | ubuntu | - |
| Group | ubuntu | ubuntu | - |
| **Effect** | Owner & Group can write | Only owner can write | Restricted write access |

### File: script.sh
| Aspect | Before | After | Command |
|--------|--------|-------|---------|
| Permissions | `-rw-rw-r--` (664) | `-rwxrwxr-x` (775) | `chmod +x script.sh` |
| Owner | ubuntu | ubuntu | - |
| Group | ubuntu | ubuntu | - |
| **Effect** | Not executable | Executable | Added execute permission |

### Directory: project/
| Aspect | Before | After | Command |
|--------|--------|-------|---------|
| Permissions | `drwxrwxr-x` (775) | `drwxrwxr-x` (775) | `chmod 755 project` |
| Owner | ubuntu | ubuntu | - |
| Group | ubuntu | devs | `sudo chgrp -R devs project/` |
| **Effect** | Default dir perms | Group owner changed to 'devs' | - |

---

## Commands Used

### File Creation
```bash
touch script.sh devops.txt notes.txt
echo 'Devops Practice' > devops.txt
echo 'Line 1' > notes.txt
echo 'Line 2' >> notes.txt
```

### File Reading
```bash
cat devops.txt
cat notes.txt
cat script.sh
```

### Permission Modification
```bash
chmod +x script.sh              # Add execute permission
chmod a-w devops.txt            # Remove write from all
chmod 640 notes.txt             # Set to rw-r-----
chmod 755 project               # Set directory to rwxr-xr-x
```

### Group Management
```bash
sudo groupadd devs              # Create 'devs' group
sudo usermod -aG devs tokyo     # Add user 'tokyo' to 'devs' group
sudo chgrp devs project         # Change group owner to 'devs'
sudo chgrp -R devs project/     # Recursively change group for directory contents
```

### Testing with Another User
```bash
sudo useradd -m tokyo           # Create new user
sudo passwd tokyo               # Set password for tokyo
sudo -u tokyo bash              # Switch to tokyo user
```

---

## Permission Analysis

### Understanding Permission Format: `rwxrwxrwx`

- **Position 1-3 (Owner)**: Owner permissions
- **Position 4-6 (Group)**: Group permissions  
- **Position 7-9 (Others)**: Other users permissions

| Char | Value | Meaning |
|------|-------|---------|
| r | 4 | Read |
| w | 2 | Write |
| x | 1 | Execute |
| - | 0 | No permission |

### Final Permissions State
```
-r--r--r-- 1 ubuntu ubuntu   16 Jun  8 16:03 devops.txt    (444 - read-only)
-rw-r----- 1 ubuntu ubuntu   14 Jun  8 16:04 notes.txt     (640 - owner rw, group r, others none)
drwxrwxr-x 2 ubuntu devs   4096 Jun  8 16:40 project       (775 - owner rwx, group rwx, others rx)
-rwxrwxr-x 1 ubuntu devs     52 Jun  8 16:12 script.sh     (775 - executable)
```

---

## Testing Permissions & Error Messages

### Test 1: Write to Read-Only File
```bash
ubuntu@ip-172-31-5-116:~/day-10$ echo "test" >> devops.txt
-bash: devops.txt: Permission denied
```
**Result**: ❌ Failed - Cannot write to read-only file

### Test 2: Execute Script Without Permission
```bash
ubuntu@ip-172-31-5-116:~/day-10$ ./script.sh
-bash: ./script.sh: Permission denied
```
**Result**: ❌ Failed - Cannot execute without x permission

### Test 3: Execute Script With Permission
```bash
ubuntu@ip-172-31-5-116:~/day-10$ chmod +x script.sh
ubuntu@ip-172-31-5-116:~/day-10$ ./script.sh
Hello day-10 of Devops practice
```
**Result**: ✅ Success - Script executed successfully

### Test 4: Cross-User Access (tokyo user)
```bash
tokyo@ip-172-31-5-116:/home/ubuntu/day-10/project$ ./script.sh
Hello day-10 of Devops practice
```
**Result**: ✅ Success - tokyo can execute because:
- script.sh has group execute permission (x)
- tokyo is in 'devs' group
- devs is the group owner of script.sh

---

## What I Learned

### 1. **Permission Inheritance & Group Management**
   - File permissions can be modified using both symbolic (`chmod +x`) and octal (`chmod 755`) notations
   - Group ownership is crucial for multi-user environments
   - Users inherit permissions of groups they belong to
   - A user in the correct group can bypass strict owner-only permissions

### 2. **Practical Permission Levels**
   - **644/664**: Regular files (rw for owner, r for others)
   - **755/775**: Directories and executable scripts (rwx for owner, rx for others)
   - **640**: Restricted files (rw for owner, r for group, nothing for others)
   - **444**: Read-only archives (r for all, no write at all)

### 3. **Real-World Application**
   - Bash scripts require execute permission to run (`chmod +x`)
   - Read-only files (`-r--r--r--`) protect important configs from accidental modification
   - Group-based permissions enable secure collaboration (e.g., dev team with 'devs' group)
   - User switching with `sudo -u` helps test different permission scenarios
   - Error messages clearly indicate permission failures, making debugging easier

---

## Key Takeaways

- ✅ Created files using `touch`, `cat`, and `vim`
- ✅ Modified permissions using `chmod` (symbolic and octal)
- ✅ Managed group ownership with `chgrp` and `usermod`
- ✅ Tested cross-user access with proper group permissions
- ✅ Understood permission hierarchy: Owner → Group → Others
- ✅ Learned read-only prevents writes, execute permission allows running scripts

---

*Challenge completed on: June 8, 2026*  
*User: ubuntu (UID: 1000)*  
*Tested with: tokyo user (UID: 1001)*
