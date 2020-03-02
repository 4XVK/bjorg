#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP HOSTS NOW OK THANKS"

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