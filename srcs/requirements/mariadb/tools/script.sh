#!/bin/bash

set -e

# Check if passwords and environment variables are set
if [ -z "$MYSQL_USER" ]; then
	echo "ERROR: MYSQL_USER is not set. Exiting."
	exit 1
fi

if [ ! -f /run/secrets/mysql_password ]; then
	echo "ERROR: Secrets not found. Exiting."
	exit 1
fi

# get secrets password
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

# init the database if not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing database..."
	mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

	echo "Starting MariaDB temporarily"
	mysqld_safe --datadir=/var/lib/mysql --skip-networking &
	pid="$!"

	echo "Waiting for MariaDB to start..."
	until mysqladmin ping --silent; do
		sleep 1
	done

	echo "Creating database and user"
	mysql -u root << EOF
		CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
		CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
		GRANT ALL PRIVILEGES ON wordpress.* TO '$MYSQL_USER'@'%';
		FLUSH PRIVILEGES;
EOF

	echo "Setting root password"
	mysql -u root << EOF
		ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$MYSQL_PASSWORD');
		FLUSH PRIVILEGES;
EOF

	# shut down MariaDB after initialization
	mysqladmin -uroot -p$MYSQL_PASSWORD shutdown

	# wait for MariaDB to shut down
	wait "$pid"
else
	echo "Database already initialized."
fi

# start MariaDB normally
exec mysqld --user=mysql --datadir=/var/lib/mysql
