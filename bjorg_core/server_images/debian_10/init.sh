#!/usr/bin/env bash
HISTSIZE=0
set +o history

#
# This script kickstarts the build process for a basic server instance.
#
# OS: debian 10


# Make sure args are supplied
if [ $# -eq 0 ]
  then
    err "ERR | -FQDN -HOSTNAME -SSH_PORT -CERTBOT_EMAIL"
    exit 1
fi

FQDN=$1
HOSTNAME=$2
SSH_PORT=$3
CERTBOT_EMAIL=$4

PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 63)

apt-get update && apt-get -y upgrade
apt-get install -y unattended-upgrades build-essential git gnupg autossh

# Do hosts things
. hosts.sh

# Do users stuff
. users.sh

# Lock SSH access down
. secure_ssh.sh

# Activate firewall
. firewall.sh

read -p "Web? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  . web.sh
fi

read -p "MySQL? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  . mysql.sh
fi

read -p "PHP? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  . php.sh
fi

read -p "Python? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  . python.sh
fi