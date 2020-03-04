#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP USERS NOW OK THANKS"

# Create a super user
adduser "$HOSTNAME" --gecos "" --disabled-password
usermod -aG sudo "$HOSTNAME"
echo "$HOSTNAME":"$PASSWORD" | chpasswd

# Make password generically available
echo "$PASSWORD" > /home/"$HOSTNAME"/bjorg_core/env_core/"$HOSTNAME"_auth

# Transplant bjorg_core for user
cp -a /root/bjorg-master/bjorg_core /home/"$HOSTNAME"

# Transplant sshkey for user
mkdir /home/"$HOSTNAME"/.ssh
cp -a /root/.ssh/. /home/"$HOSTNAME"/.ssh/

# Make sure new user is the owner of stuff we transplanted
chown -R "HOSTNAME" /home/"$HOSTNAME"/