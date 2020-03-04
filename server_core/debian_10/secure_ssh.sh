#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP SSH NOW OK THANKS"

file=/etc/ssh/sshd_config
sed -i 's/#Port .*/Port '"$SSH_PORT"'/' $file
sed -i 's/#AddressFamily .*/#AddressFamily inet/' $file
sed -i 's/PermitRootLogin .*/PermitRootLogin no/' $file
sed -i 's/#PasswordAuthentication .*/PasswordAuthentication no/' $file