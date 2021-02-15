#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP USERS NOW OK THANKS"

# Create a super user
adduser "$HOSTNAME" --gecos "" --disabled-password
usermod -aG sudo "$HOSTNAME"
echo "$HOSTNAME":"$PASSWORD" | chpasswd

# Transplant bjorg for user
cp -a /root/bjorg-master/bjorg /home/"$HOSTNAME"

# Make password generically available
echo "$PASSWORD" > /home/"$HOSTNAME"/bjorg/auth_core/local_auth

# Transplant sshkey for user
mkdir /home/"$HOSTNAME"/.ssh
cp -a /root/.ssh/. /home/"$HOSTNAME"/.ssh/

# Make sure new user is the owner of stuff we transplanted
chown -R "$HOSTNAME":"$HOSTNAME" /home/"$HOSTNAME"/bjorg/
chown -R "$HOSTNAME":"$HOSTNAME" /home/"$HOSTNAME"/.ssh/

# generate rsa key pair and ed25519 key pairs
su "$HOSTNAME" bash -c 'ssh-keygen -t rsa -b 4096 -o -a 100 -f ~/.ssh/id_rsa -N ""'
su "$HOSTNAME" bash -c 'ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -N ""'

# duplicate key pairs into auth_core
su "$HOSTNAME" bash -c 'cp ~/.ssh/id_* ~/bjorg/auth_core/'