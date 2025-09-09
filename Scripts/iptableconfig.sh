#!/bin/bash
LBR_IP="172.16.238.14"
PORT="5004"
HOSTS=("172.16.238.10" "172.16.238.11" "172.16.238.12")
USER=("tony" "mike" "john")
PASSWORDS=("Ir0nM@n" "Am3ric@" "BigGr33n")
HOSTNAMES=("stapp01" "stapp02" "stapp03")
if ! command -v sshpass &> /dev/null; then
    echo "sshpass could not be found, installing it now..."
    yum  update && yum install -y sshpass
fi
echo "Starting firewall configuration on all app servers..."
echo "----------------------------------------------------"
for i in "${!HOSTS[@]}"; do
     HOST=${HOSTS[$i]}
     USER=${USER[$i]}
     PASSWORD=${PASSWORDS[$i]}
     HOSTNAME=${HOSTNAMES[$i]}
     echo "Connecting to $HOSTNAME ($HOST)..."
     REMOTE_COMMANDS="
     yum install -y iptables-services;
     systemctl start iptables;
     systemctl enable iptables;
     iptables -A INPUT -p tcp -s $LBR_IP --dport $PORT -j ACCEPT;
     iptables -A INPUT -p tcp --dport $PORT -j REJECT;
     service iptables save;
     echo 'Firewall configuration completed on $HOSTNAME ($HOST).';
    "
    sshpass -p "$PASSWORD" ssh -o ConnectTimeout=10 StrictHostKeyChecking=no "$USER@$HOST" "echo '$PASSWORD' | sudo -S bash -c \"$REMOTE_COMMANDS\""
    if [$? -ne 0]; then
        echo "Failed to configure firewall on $HOSTNAME ($HOST). Please check the connection and credentials."
    else
        echo "Successfully configured firewall on $HOSTNAME ($HOST)."
    fi
    echo "----------------------------------------------------"
done
echo "Firewall configuration completed on all app servers."
