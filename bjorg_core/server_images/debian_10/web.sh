#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP WEB NOW OK THANKS"

apt install -y nginx certbot python-certbot-nginx

# Transfer templates
echo "Transferring templates..."
cat templates/nginx.default > /etc/nginx/sites-available/default
sed -i 's/server_name _.*/server_name '"$FQDN"';/' /etc/nginx/sites-available/default
cat templates/index.html > /var/www/html/index.html

# Full stop start
service nginx stop
service nginx start

# Request SSL
# Try for --hsts and --uir even though they aren't currently supported with the nginx module
echo "Setting up SSL..."
certbot -n --agree-tos --email "$CERTBOT_EMAIL" --authenticator webroot -w /var/www/html/ --installer nginx --redirect --hsts --uir --domain "$FQDN"

service nginx reload