# Create a User with Interactive and Non-Interactive Shells on Linux

## Task Description
This task demonstrates how to create users with different types of shells on a Linux system. Understanding the difference between interactive and non-interactive shells is crucial for system administration and security.

## Objective
Learn how to create users with:
1. Interactive shells (for human users who need terminal access)
2. Non-interactive shells (for service accounts that don't require login)

## Prerequisites
- Root or sudo privileges
- Basic understanding of Linux user management
- Access to a Linux terminal

## Concepts

### Interactive Shell
An interactive shell is one that accepts commands from the user. When a user logs in, they are provided with an interactive shell (like bash, zsh, etc.) where they can execute commands.

### Non-Interactive Shell
A non-interactive shell, typically `/sbin/nologin` or `/bin/false`, prevents users from logging into the system interactively. This is commonly used for service accounts or system users that run specific processes but shouldn't have login access.

## Commands and Steps

### 1. Create a User with an Interactive Shell (Default)

```bash
# Create a new user with default interactive shell (usually /bin/bash)
sudo useradd -m -s /bin/bash interactive_user

# Set password for the user
sudo passwd interactive_user

# Verify the user's shell
grep interactive_user /etc/passwd
```

**Expected Output:**
```
interactive_user:x:1001:1001::/home/interactive_user:/bin/bash
```

### 2. Create a User with a Non-Interactive Shell

```bash
# Create a user with /sbin/nologin shell
sudo useradd -m -s /sbin/nologin service_user

# Verify the user's shell
grep service_user /etc/passwd
```

**Expected Output:**
```
service_user:x:1002:1002::/home/service_user:/sbin/nologin
```

### 3. Alternative Non-Interactive Shell (/bin/false)

```bash
# Create a user with /bin/false shell
sudo useradd -m -s /bin/false another_service_user

# Verify the user's shell
grep another_service_user /etc/passwd
```

### 4. Modify Existing User's Shell

```bash
# Change an existing user's shell to non-interactive
sudo usermod -s /sbin/nologin interactive_user

# Change back to interactive shell
sudo usermod -s /bin/bash interactive_user
```

### 5. Test the Shells

```bash
# Try to switch to the interactive user (should work)
sudo su - interactive_user

# Try to switch to the non-interactive user (should fail with message)
sudo su - service_user
# Output: This account is currently not available.
```

## Command Breakdown

### useradd Options:
- `-m` : Create the user's home directory
- `-s` : Specify the login shell
- `-c` : Add a comment/description
- `-u` : Specify user ID
- `-g` : Specify primary group

### Common Shell Paths:
- `/bin/bash` - Bourne Again Shell (interactive)
- `/bin/sh` - Default system shell (interactive)
- `/bin/zsh` - Z Shell (interactive)
- `/sbin/nologin` - Prevents login, displays message
- `/bin/false` - Prevents login, returns false

## Practical Use Cases

### Interactive Shells:
- Regular user accounts
- Developer accounts
- System administrators
- Any user who needs terminal access

### Non-Interactive Shells:
- Web server users (nginx, apache)
- Database users (mysql, postgres)
- Application service accounts
- Security-sensitive accounts that should only run specific services

## Security Considerations

1. **Principle of Least Privilege**: Service accounts should not have interactive shell access
2. **Audit Trail**: Monitor users with interactive shells
3. **Service Isolation**: Use non-interactive shells for automated processes
4. **Password Policy**: Even non-interactive users should have strong passwords or use key-based authentication

## Verification and Testing

```bash
# List all users with their shells
cat /etc/passwd | awk -F: '{print $1, $7}'

# Count users with interactive shells
grep -E '(/bin/bash|/bin/sh|/bin/zsh)$' /etc/passwd | wc -l

# Count users with non-interactive shells
grep -E '(/sbin/nologin|/bin/false)$' /etc/passwd | wc -l

# View available shells on the system
cat /etc/shells
```

## Cleanup (Optional)

```bash
# Remove the test users
sudo userdel -r interactive_user
sudo userdel -r service_user
sudo userdel -r another_service_user
```

## My Experience

While working through this task, I learned:

1. **Shell Assignment Matters**: The difference between `/sbin/nologin` and `/bin/false` is subtle but important. `/sbin/nologin` displays a polite message, while `/bin/false` simply returns an error.

2. **Security Best Practice**: After experimenting with both shell types, I understand why service accounts (like www-data, mysql, etc.) use non-interactive shells - it significantly reduces the attack surface.

3. **Common Mistake**: Initially forgot to use the `-m` flag, which meant the home directory wasn't created. This caused issues when trying to set up environment variables for the user.

4. **Testing Importance**: Actually attempting to login as both user types (`su - username`) really drove home the practical difference between interactive and non-interactive shells.

5. **Real-World Application**: This knowledge is immediately applicable when setting up web servers, databases, or any service that requires a dedicated user account.

## Key Takeaways

- Interactive shells are for humans who need to execute commands
- Non-interactive shells are for service accounts that shouldn't login
- Use `useradd -s` to specify the shell during user creation
- Use `usermod -s` to change an existing user's shell
- Always verify user configuration with `grep username /etc/passwd`
- Apply the principle of least privilege: if a user doesn't need shell access, don't give it to them

## References

- `man useradd` - User creation command manual
- `man usermod` - User modification command manual
- `/etc/passwd` - User account information
- `/etc/shells` - List of valid login shells

## Date Completed
October 12, 2025

---

**Repository**: 100 Days of DevOps - Linux/Bash by KodeKloud
**Category**: Linux User Management
**Difficulty**: Beginner to Intermediate
