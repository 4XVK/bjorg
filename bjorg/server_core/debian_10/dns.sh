#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP DNS NOW OK YUP"

apt install -y bind9 bind9utils bind9-doc

# Transfer intial config and DNS templates
echo "Transferring wait..."
#mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bk
#cat templates/nginx.conf > /etc/nginx/nginx.conf
#cat templates/nginx.default > /etc/nginx/sites-available/default
#sed -i 's/server_name _.*/server_name '"$FQDN"';/' /etc/nginx/sites-available/default
#cat templates/index.html > /var/www/html/index.html

# Full stop start
service bind9 stop
service bind9 start

