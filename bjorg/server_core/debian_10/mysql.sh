#!/usr/bin/env bash
HISTSIZE=0
set +o history

echo "SETUP UP MYSQL NOW OK THANKS"
apt install -y mariadb-server

# Create a user for use by web apps with access to most tables
echo "Creating MYSQL user..."
mysql -e "GRANT ALL ON *.* TO 'webmaster'@'localhost' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;"

# Secure maria from it's dangerous defaults
echo "Removing anonymous users..."
mysql -e "DELETE FROM mysql.user WHERE User='';"

echo "Preventing remove root connections!"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

echo "Dropping test databases..."
mysql -e "DROP DATABASE IF EXISTS test;"
echo "Removing privileges on test database..."
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

echo "Flushing..."
mysql -e "FLUSH PRIVILEGES;"

echo "Copying cnf..."
\cp templates/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

#
#esc_pass=`basic_single_escape "$password1"`
#    do_query "UPDATE mysql.user SET Password=PASSWORD('$esc_pass') WHERE User='root';"