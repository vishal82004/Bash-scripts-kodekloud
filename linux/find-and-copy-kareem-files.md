# Find and Copy Files Owned by User Kareem

## Task Description
Find all files owned by user `kareem` under `/home/usersdata` on App Server 1 and copy them to `/media` while preserving the folder structure.

## Solution

### Command Used
```bash
find /home/usersdata -user kareem -exec cp --parents {} /media \;
```

### Explanation

- **`find /home/usersdata`**: Searches for files starting from the `/home/usersdata` directory
- **`-user kareem`**: Filters to find only files owned by user `kareem`
- **`-exec cp --parents {} /media \;`**: Executes the `cp` command for each found file
  - `--parents`: Preserves the directory structure (creates parent directories as needed)
  - `{}`: Placeholder for each file found by the `find` command
  - `/media`: Destination directory where files will be copied
  - `\;`: Terminates the `-exec` command

### Alternative Solution
```bash
find /home/usersdata -user kareem -exec cp --parents {} /media +
```

Using `+` instead of `\;` allows `cp` to process multiple files at once, which is more efficient for large numbers of files.

## Key Points
- The `--parents` option ensures that the complete directory path from the source is recreated in the destination
- This maintains the organizational structure of the files
- All files owned by `kareem` are copied, regardless of their depth in the directory tree
