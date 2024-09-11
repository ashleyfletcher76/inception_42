#!/bin/bash

# check if passwords and or environment variables are there
if [ -z "$MYSQL_USER" ] || [ -z "MYSQL_ADMIN" ]; then
	echo "ERROR: MYSQL_USER or MYSQL_ADMIN is not set. Exiting."
	exit 1
fi

if [ ! -f /run/secrets/mysql_password ] || [ ! -f /run/secrets/mysql_admin_password ]; then
	echo "ERROR: Secrets not found. Exiting."
	exit 1
fi

# read the secrets files
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)
MYSQL_ADMIN_PASSWORD=$(cat /run/secrets/mysql_admin_password)

# use these variables for the init.sql
sed -i "s/password_placeholder/$MYSQL_PASSWORD/g" /etc/mysql/init.sql
sed -i "s/admin_password_placeholder/$MYSQL_ADMIN_PASSWORD/g" /etc/mysql/init.sql
sed -i "s/\${MYSQL_USER}/$MYSQL_USER/g" /etc/mysql/init.sql
sed -i "s/\${MYSQL_ADMIN}/$MYSQL_ADMIN/g" /etc/mysql/init.sql

# start in background
mysqld_safe &

sleep 5

DB_EXISTS=$(echo "SHOW DATABASES LIKE 'wordpress';" | mysql -u root -p"$MYSQL_ADMIN_PASSWORD" -s --skip-column-names)

# now check if database already exists
if [ "$DB_EXISTS" != "wordpress" ]; then
	echo "Database does not exist. Initialising.."
	mysql_install_db
	mysql -u root -p"$MYSQL_ADMIN_PASSWORD" < /etc/mysql/init.sql
else
	echo "Database already exists."
fi

wait

