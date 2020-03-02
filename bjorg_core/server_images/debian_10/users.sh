#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP USERS NOW OK THANKS"

# Create a super user
adduser "$HOSTNAME" --gecos "" --disabled-password
usermod -aG sudo "$HOSTNAME"
echo "$HOSTNAME":"$PASSWORD" | chpasswd