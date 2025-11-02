# Disable Root SSH Login on App Servers

## Overview
Following a recent security audit, the xFusionCorp Industries team implemented new security protocols that **restrict direct root SSH login** across all application servers.  
This guide explains how to manually disable root SSH login on all app servers in the Stratos Datacenter.

---

## Server Details

| Server   | IP Address      | Hostname                         | User   | Password | Purpose         |
|-----------|----------------|----------------------------------|--------|-----------|----------------|
| stapp01  | 172.16.238.10  | stapp01.stratos.xfusioncorp.com  | tony   | Ir0nM@n   | Nautilus App 1 |
| stapp02  | 172.16.238.11  | stapp02.stratos.xfusioncorp.com  | steve  | Am3ric@   | Nautilus App 2 |
| stapp03  | 172.16.238.12  | stapp03.stratos.xfusioncorp.com  | banner | BigGr33n  | Nautilus App 3 |

---

## Steps to Disable Root SSH Login

### 1. SSH into Each App Server
From the jump host, connect to each app server one by one:

```bash
ssh tony@stapp01
ssh steve@stapp02
ssh banner@stapp03
```

Use the corresponding passwords when prompted.

### 2. Update SSH Configuration
Once logged in to an app server, execute the following commands:

```bash
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo grep PermitRootLogin /etc/ssh/sshd_config
```

Expected output:
```
PermitRootLogin no
```

✅ This confirms that direct root login is disabled.

### 3. Repeat on All App Servers
Repeat Step 2 for each of the three app servers (stapp01, stapp02, stapp03).

---

## Verification
Attempt to SSH as root to verify that login is now blocked:

```bash
ssh root@stapp01
```

You should receive a **Permission denied** message — this confirms the configuration is applied successfully.

---

