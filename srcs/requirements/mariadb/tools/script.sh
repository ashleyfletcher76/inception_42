#!/bin/bash

set -ex

# check if passwords and environment variables are set
if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_DATABASE" ]; then
    echo "ERROR: MYSQL_USER or MYSQL_DATABASE is not set. Exiting."
    exit 1
fi

if [ ! -f /run/secrets/mysql_password ]; then
    echo "ERROR: Secrets not found. Exiting."
    exit 1
fi

# get secrets password
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

echo "MYSQL_USER: $MYSQL_USER"
echo "MYSQL_DATABASE: $MYSQL_DATABASE"
echo "MYSQL_PASSWORD: $MYSQL_PASSWORD"

# init database if not already
if [ ! -d "/var/lib/mysql/mysql/.initialized" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal
	echo "Database files created."

    echo "Starting MariaDB temporarily"
    mysqld_safe --datadir=/var/lib/mysql --skip-networking &
    pid="$!"
    echo "MariaDB temporary PID: $pid"

    echo "Waiting for MariaDB to start..."
    until mysqladmin ping --silent; do
        sleep 1
    done

    echo "Creating database and user"
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Setting root password"
    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
EOF

    # shut down MariaDB after initialization
    mysqladmin -uroot -p"$MYSQL_PASSWORD" shutdown

    # wait for MariaDB to shut down
    wait "$pid"

	touch /var/lib/mysql/.initialized
    chown mysql:mysql /var/lib/mysql/.initialized
else
    echo "Database already initialized."
fi

# start MariaDB normally
exec mysqld --user=mysql --datadir=/var/lib/mysql