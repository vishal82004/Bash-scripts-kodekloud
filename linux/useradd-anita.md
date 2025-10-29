# Runbook: Create User Anita Without Home Directory

## Objective
Create a new user account named 'anita' without creating a home directory.

## Prerequisites
- Root or sudo access
- Linux system with useradd utility

## Command
```bash
sudo useradd -M anita
```

## Explanation
- `useradd`: Command to create a new user
- `-M`: Option to create user without home directory
- `anita`: Username

## Verification
Verify the user was created without a home directory:
```bash
# Check if user exists
id anita

# Verify no home directory was created
ls -ld /home/anita
# Should return: ls: cannot access '/home/anita': No such file or directory
```

## Additional Options (if needed)
- Set password: `sudo passwd anita`
- Specify shell: `sudo useradd -M -s /bin/bash anita`
- Add to group: `sudo useradd -M -G groupname anita`

## Notes
- The `-M` flag prevents creation of home directory
- User will be created but may have limited functionality without a home directory
- Default shell and other settings from /etc/default/useradd will apply
