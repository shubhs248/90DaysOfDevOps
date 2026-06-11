# Day 13 Challenge – Linux Volume Management (LVM)

> Hands-on LVM practice on an AWS EC2 Ubuntu instance. Notes below are based on today's session in `practice.txt`.

---

## Resources Created

| Resource | Name / Path | Details |
|----------|-------------|---------|
| Virtual disk | `/root/disk1.img` | 1 GiB file created with `dd`, attached as `/dev/loop5` |
| Physical Volume (PV) | `/dev/loop5` | ~1020 MiB |
| Volume Group (VG) | `devops-vg` | Built from `/dev/loop5` |
| Logical Volume (LV) | `app-data` | Started at 500 MiB, extended to 700 MiB |
| Filesystem | ext4 on `/dev/devops-vg/app-data` | UUID: `b216517d-39d6-435a-bd51-1b629463d59d` |
| Mount point | `/mnt/app-data` | Mounted and resized online |

---

## Task 1: Check Current Storage

**Commands:**

```bash
sudo -i
sudo pvs
sudo vgs
sudo lvs
lsblk
df -h
```

**Observations:**

- Before creating any LVM resources, `pvs`, `vgs`, and `lvs` returned empty — no existing LVM setup on the instance.
- Root disk: `/dev/xvda` (30G) with partitions for `/`, `/boot`, and `/boot/efi`.
- Several snap loop devices were already present (`loop0`–`loop3`).

---

## Task 2: Create a Virtual Disk (No Spare Block Device)

The README suggests using a loop device when no extra disk is attached. First attempt failed because `/tmp` was full.

**Failed attempt (no space on `/tmp`):**

```bash
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
# dd: IO error: No space left on device

df -h /tmp
# Filesystem      Size  Used Avail Use% Mounted on
# tmpfs           476M  476M     0 100% /tmp
```

**Workaround — create disk under `/root` instead:**

```bash
dd if=/dev/zero of=/root/disk1.img bs=1M count=1024
# 1024+0 records in
# 1024+0 records out
# 1073741824 bytes (1.1 GB, 1.0 GiB) copied

losetup -fP /root/disk1.img
losetup -a
# /dev/loop5: [51713]:3105 (/root/disk1.img)
```

**Cleanup of the smaller `/tmp` disk (300 MiB test file):**

```bash
losetup -d /dev/loop4
rm /tmp/disk1.img
```

---

## Task 3: Create Physical Volume

```bash
which pvcreate          # /usr/sbin/pvcreate
pvcreate /dev/loop5
# Physical volume "/dev/loop5" successfully created.
```

**Verification:**

```bash
pvs
#   PV         VG        Fmt  Attr PSize    PFree
#   /dev/loop5 devops-vg lvm2 a--  1020.00m 520.00m
```

---

## Task 4: Create Volume Group

```bash
vgcreate devops-vg /dev/loop5
# Volume group "devops-vg" successfully created
```

**Verification:**

```bash
vgs
#   VG        #PV #LV #SN Attr   VSize    VFree
#   devops-vg   1   1   0 wz--n- 1020.00m 520.00m
```

---

## Task 5: Create Logical Volume

```bash
lvcreate -L 500M -n app-data devops-vg
# Logical volume "app-data" created.
```

**Verification:**

```bash
lvs
#   LV       VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
#   app-data devops-vg -wi-ao---- 500.00m
```

---

## Task 6: Format and Mount

```bash
mkfs.ext4 /dev/devops-vg/app-data
mkdir -p /mnt/app-data
mount /dev/devops-vg/app-data /mnt/app-data
df -h /mnt/app-data
```

**Output after mount:**

```
Filesystem                        Size  Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data  452M  152K  417M   1% /mnt/app-data
```

**Block device tree (`lsblk`):**

```
loop5                    7:5    0    1G  0 loop
└─devops--vg-app--data 252:0    0  500M  0 lvm  /mnt/app-data
xvda                   202:0    0   30G  0 disk
├─xvda1                202:1    0 28.9G  0 part /
├─xvda13               202:13   0 1023M  0 part /boot
├─xvda14               202:14   0    4M  0 part
└─xvda15               202:15   0  106M  0 part /boot/efi
```

---

## Task 7: Extend the Volume

**Wrong command (absolute size, not an increase):**

```bash
lvextend -L 200M /dev/devops-vg/app-data
# New size given (50 extents) not larger than existing size (125 extents)
```

**Correct command — add 200 MiB to existing size:**

```bash
lvextend -L +200M /dev/devops-vg/app-data
# Size of logical volume devops-vg/app-data changed from 500.00 MiB (125 extents) to 700.00 MiB (175 extents).
# Logical volume devops-vg/app-data successfully resized.
```

After `lvextend`, `df -h` still showed **452M** — the LV grew but the filesystem did not yet.

**Grow the ext4 filesystem to use the new space:**

```bash
resize2fs /dev/devops-vg/app-data
# Filesystem at /dev/devops-vg/app-data is mounted on /mnt/app-data; on-line resizing required
# The filesystem on /dev/devops-vg/app-data is now 179200 (4k) blocks long.
```

**Final size:**

```
Filesystem                        Size  Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data  637M  152K  594M   1% /mnt/app-data
```

---

## LVM Stack Summary

```
Physical Volume (PV)     Volume Group (VG)      Logical Volume (LV)       Filesystem + Mount
/dev/loop5        →     devops-vg        →     app-data (700 MiB)   →    ext4 on /mnt/app-data
```

| Layer | Command to inspect | What it shows |
|-------|-------------------|---------------|
| PV | `pvs` | Physical disks/partitions enrolled in LVM |
| VG | `vgs` | Pool of storage combining one or more PVs |
| LV | `lvs` | Carved-out volumes from a VG, used like block devices |
| Mount | `df -h`, `lsblk` | Filesystem size and mount point |

---

## Mistakes & Fixes

| Mistake | Fix |
|---------|-----|
| `dd` to `/tmp` when tmpfs is 100% full | Check `df -h /tmp` first; use `/root/disk1.img` or another path with free space |
| `lvextend -L 200M` (absolute size smaller than current) | Use `lvextend -L +200M` to **add** 200 MiB to the existing LV |
| `df -h` unchanged after `lvextend` | Run `resize2fs` (ext4) or `xfs_growfs` (xfs) so the filesystem fills the larger LV |

---

## Key Learnings

### 1. LVM adds a flexible layer between disks and filesystems

Instead of resizing a raw partition directly, LVM lets you combine disks into a **volume group** and slice out **logical volumes** that can grow or shrink (within available space). This is why cloud and on-prem servers use LVM for data volumes that need to expand over time.

### 2. Extending storage is a two-step process

`lvextend` only grows the **logical volume** (the block device). The **filesystem** on top must be resized separately — `resize2fs` for ext4. Skipping the second step leaves free space inside the LV that the OS cannot use yet.

### 3. Loop devices are a solid lab substitute for real disks

When no spare `/dev/sdb` or EBS volume is attached, `dd` + `losetup` creates a block device (`/dev/loop5`) that LVM treats like a physical disk. Always confirm the loop device with `losetup -a` before running `pvcreate`.

---

## DevOps Relevance

- **Elastic storage on servers**: Application data directories (`/var/lib`, `/opt/app-data`) often sit on LVM-backed volumes so ops can extend them without downtime.
- **Cloud attach workflows**: Add a new EBS volume → `pvcreate` → `vgextend` → `lvextend` → `resize2fs` is a common production pattern.
- **Snapshots & backups**: LVM snapshots (not covered today) let you freeze a volume for consistent backups while the app keeps running.
- **Capacity planning**: `pvs` / `vgs` / `lvs` quickly show how much free space remains in the VG before you provision another LV.

---

## Summary

Day 13 covered end-to-end LVM on a single virtual disk:

- Created a 1 GiB loop-backed disk and initialized it as a physical volume
- Built volume group `devops-vg` and logical volume `app-data` (500 MiB)
- Formatted with ext4, mounted at `/mnt/app-data`, and verified with `lsblk`, `pvs`, `vgs`, `lvs`
- Extended the LV by 200 MiB and grew the filesystem online with `resize2fs` (452M → 637M usable)

This foundation prepares for real-world scenarios: attaching cloud volumes, growing application data partitions, and managing storage without repartitioning the root disk.

---

**Challenge Completed**: Day 13 – Linux Volume Management (LVM) ✅

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham
