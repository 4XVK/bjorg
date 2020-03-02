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

# ALTER SYS HEADERS for iptables-persistent installation
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

apt-get update && apt-get -y upgrade
apt-get install -y unattended-upgrades build-essential git iptables-persistent gnupg autossh

# Get public ipv6/4 on eth0
ipv6_raw_public=$(/sbin/ip -o -6 addr show eth0 | sed -e 's/^.*inet6 \([^ ]\+\).*/\1/')
ipv4_raw_public=$(/sbin/ip -o -4 addr show eth0 | sed -e 's/^.*inet \([^ ]\+\).*/\1/')
ipv6_public=${ipv6_raw_public%%/*}
ipv4_public=${ipv4_raw_public%%/*}

# Add public entries to /etc/hosts
echo "$HOSTNAME" > /etc/hostname
cat <<EOT >> /etc/hosts

# public entries
$ipv6_public $HOSTNAME.$FQDN $HOSTNAME
$ipv4_public $HOSTNAME.$FQDN $HOSTNAME
EOT

# Create a super user
adduser "$HOSTNAME" --gecos "" --disabled-password
adduser "$HOSTNAME" sudo
usermod -aG sudo "$HOSTNAME"
echo "$HOSTNAME":"$PASSWORD" | chpasswd
echo "$PASSWORD" > /home/"$HOSTNAME"/bjorg_core/auth

# Give user an sshkey, and transplant bjorg core
cp -a /root/bjorg-master/bjorg_core /home/"$HOSTNAME"
mkdir /home/"$HOSTNAME"/.ssh
cp -a /root/.ssh/. /home/"$HOSTNAME"/.ssh/

# Lock SSH access down
file=/etc/ssh/sshd_config
sed -i 's/#Port .*/Port '"$SSH_PORT"'/' $file
sed -i 's/#AddressFamily .*/#AddressFamily inet/' $file
sed -i 's/PermitRootLogin .*/PermitRootLogin no/' $file
sed -i 's/#PasswordAuthentication .*/PasswordAuthentication no/' $file

# Edit ipv4/6 templates add SSH_PORT
sed -i 's/PORTGOESHERE/'"$SSH_PORT"'/g' templates/ip4tables
sed -i 's/PORTGOESHERE/'"$SSH_PORT"'/g' templates/ip4tables_web
sed -i 's/PORTGOESHERE/'"$SSH_PORT"'/g' templates/ip6tables
sed -i 's/PORTGOESHERE/'"$SSH_PORT"'/g' templates/ip6tables_web

# Activate firewall rules with web access, then make persistent
awk '1' templates/ip4tables_web | iptables-restore
awk '1' templates/ip6tables_web | ip6tables-restore

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
