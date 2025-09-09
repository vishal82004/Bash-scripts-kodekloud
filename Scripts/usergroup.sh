#!/bin/bash
HOSTS=("172.16.238.10" "172.16.238.11" "172.16.238.12")
USERS=("tony" "steve" "banner")
PASSWORDS=("Ir0nM@n" "Am3ric@" "BigGr33n")
HOSTNAMES=("stapp01" "stapp02" "stapp03")
NEW_GROUP="nautilus_sftp_users"
NEW_USER="mohammed"
if ! command -v sshpass &> /dev/null; then
    echo "Error: sshpass is not installed. Please install it to run this script."
    echo "On CentOS/RHEL, run: sudo yum install -y sshpass"
    exit 1
fi

echo "Starting user and group configuration on all app servers..."
echo "----------------------------------------------------"
for i in "${!HOSTS[@]}"; do
     HOST=${HOSTS[$i]}
     USER=${USERS[$i]}
     PASSWORD=${PASSWORDS[$i]}
     HOSTNAME=${HOSTNAMES[$i]}
     echo "Connecting to $HOSTNAME ($HOST)..."
     REMOTE_COMMANDS="
     groupadd $NEW_GROUP 2>/dev/null || echo 'Group already exists.';
     id -u $NEW_USER &>/dev/null || useradd $NEW_USER;
     usermod -aG $NEW_GROUP $NEW_USER;
     echo 'Configuration for $HOSTNAME successful.';
     "
    sshpass -p "$PASSWORD" ssh -o ConnectTimeout=10 StrictHostKeyChecking=no "$USER@$HOST" "echo '$PASSWORD' | sudo -S bash -c \"$REMOTE_COMMANDS\""
    if [ $? -ne 0 ]; then
        echo "Failed to configure user/group on $HOSTNAME ($HOST). Please check the connection and credentials."
    else
        echo "Successfully configured user/group on $HOSTNAME ($HOST)."
    fi
    echo "----------------------------------------------------"
done