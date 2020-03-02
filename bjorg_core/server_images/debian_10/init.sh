#!/usr/bin/env bash
HISTSIZE=0
set +o history

#
# This script kickstarts the build process for a basic server instance.
#
# OS: debian 10

basic_single_escape () {
    # The quoting on this sed command is a bit complex.  Single-quoted strings
    # don't allow *any* escape mechanism, so they cannot contain a single
    # quote.  The string sed gets (as argv[1]) is:  s/\(['\]\)/\\\1/g
    #
    # Inside a character class, \ and ' are not special, so the ['\] character
    # class is balanced and contains two characters.
    echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}

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

# Transplant bjorg_core
cp -a /root/bjorg-master/bjorg_core /home/"$HOSTNAME"

# Give $USER the generically generated password
echo "$PASSWORD" > /home/"$HOSTNAME"/bjorg_core/env_core/"$HOSTNAME"_auth

# Give $USER an sshkey
mkdir /home/"$HOSTNAME"/.ssh
cp -a /root/.ssh/. /home/"$HOSTNAME"/.ssh/

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