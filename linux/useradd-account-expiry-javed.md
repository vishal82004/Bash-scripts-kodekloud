# Linux User Account with Expiry Date - KodeKloud Task

## Task Description
Create a Linux user account with an expiration date using the `useradd` command.

## User Details
- **Username**: javed
- **Expiry Date**: 2024-04-15

## Commands Used

### 1. Create User with Expiry Date
```bash
sudo useradd -e 2024-04-15 javed
```

**Explanation:**
- `useradd`: Command to create a new user account
- `-e 2024-04-15`: Sets the account expiration date to April 15, 2024 (format: YYYY-MM-DD)
- `javed`: The username for the new account

### 2. Set Password for the User
```bash
sudo passwd javed
```
Enter and confirm the password when prompted.

### 3. Verify Account Expiry Date
```bash
sudo chage -l javed
```

This command displays the account aging information, including:
- Account expiration date
- Password last changed date
- Password expiration information
- Other account aging details

**Alternative verification method:**
```bash
grep javed /etc/shadow
```

### 4. Modify Expiry Date (if needed)
```bash
sudo usermod -e 2024-12-31 javed
```
Or using chage:
```bash
sudo chage -E 2024-12-31 javed
```

### 5. Remove Expiry Date (make account permanent)
```bash
sudo usermod -e "" javed
```
Or:
```bash
sudo chage -E -1 javed
```

## Important Notes

1. **Date Format**: The expiry date must be in YYYY-MM-DD format
2. **Account Behavior**: After the expiry date, the user will not be able to log in
3. **Root Privileges**: All user management commands require root/sudo privileges
4. **Verification**: Always verify the account settings after creation using `chage -l`

## Additional Options for useradd

```bash
# Create user with expiry date and other options
sudo useradd -e 2024-04-15 -m -s /bin/bash -c "Javed Ahmed" javed
```

**Options explained:**
- `-e`: Set expiry date
- `-m`: Create home directory
- `-s /bin/bash`: Set default shell
- `-c "Javed Ahmed"`: Add comment (full name)

## Checking Account Status

```bash
# Check if account is expired
sudo chage -l javed | grep "Account expires"

# Check user information
id javed

# View user entry in passwd file
grep javed /etc/passwd
```

## Common Issues and Solutions

1. **Invalid date format**: Ensure date is in YYYY-MM-DD format
2. **Permission denied**: Use sudo or run as root
3. **User already exists**: Use `usermod` instead of `useradd` to modify existing user

## Task Completion

✅ User account created with expiration date
✅ Password set for the user
✅ Account expiry verified using chage command

## Related Commands

- `userdel`: Delete a user account
- `usermod`: Modify a user account
- `chage`: Change user password aging information
- `passwd`: Change user password
