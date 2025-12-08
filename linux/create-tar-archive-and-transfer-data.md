# Create TAR Archive and Transfer Data

## Task Description
Create a compressed archive (tar.gz) of the `/data/anita` directory on the Nautilus storage server and transfer it to the `/home` directory.

## Objective
- Package developer Anita's non-confidential data from `/data/anita`
- Compress it using gzip
- Move the archive to `/home` for easy access

## Steps Executed

### Step 1: SSH into Storage Server
Connect to the Nautilus storage server (ststor01):
```bash
ssh natasha@ststor01
```

### Step 2: Escalate to Root
Gain root access to perform the archiving:
```bash
sudo su
```

### Step 3: Navigate to Root Directory
Move to the root filesystem directory:
```bash
cd /
```

### Step 4: Create Compressed TAR Archive
Create a gzip-compressed tar archive of `/data/anita` and place it directly in `/home`:
```bash
tar -czf /home/anita.tar.gz /data/anita
```

**Flag Explanation:**
- `c` = Create a new archive
- `z` = Compress with gzip (produces .tar.gz)
- `f` = Specify the filename for the archive

### Step 5: Verify Archive Creation
Confirm the archive was created successfully in `/home`:
```bash
ls -lh /home/anita.tar.gz
```

## Result
The archive `anita.tar.gz` is now available in `/home` directory for Anita to download and access her non-confidential data.

## Key Concepts Learned

### TAR vs ZIP
- **TAR (Tape Archive)**: Used primarily on Unix/Linux to bundle files together, preserving metadata (permissions, ownership, timestamps)
- **TAR.GZ**: TAR archive compressed with gzip for reduced file size
- **ZIP**: Common on Windows, bundles and compresses in one step

### When to Use tar -czf
- **Linux/Unix systems**: Preferred format for data backup and distribution
- **Preserves file metadata**: Important for system files
- **Efficient compression**: Gzip provides good compression ratio

## Practical Applications
- Backing up directories before system changes
- Archiving old data for long-term storage
- Preparing files for transfer over network
- Creating snapshots of directory structures
