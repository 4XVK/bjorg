#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP FIREWALL NOW OK THANKS"

# Add sys headers for headless iptables-persistent
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

apt-get install -y iptables-persistent

# Edit ipv4/6 templates add SSH_PORT
sed -i 's/PORTGOESHERE/'"$SSH_PORT"'/g' templates/ip4tables
sed -i 's/PORTGOESHERE/'"$SSH_PORT"'/g' templates/ip4tables_web
sed -i 's/PORTGOESHERE/'"$SSH_PORT"'/g' templates/ip6tables
sed -i 's/PORTGOESHERE/'"$SSH_PORT"'/g' templates/ip6tables_web

# Activate firewall rules with web access, then make persistent
# TODO don't default with web open
awk '1' templates/ip4tables_web | iptables-restore
awk '1' templates/ip6tables_web | ip6tables-restore