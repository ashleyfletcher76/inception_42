#!/bin/bash

# Check if passwords and environment variables are set
if [ -z "$MYSQL_USER" ]; then
    echo "ERROR: MYSQL_USER is not set. Exiting."
    exit 1
fi

if [ ! -f /run/secrets/mysql_password ]; then
    echo "ERROR: Secrets not found. Exiting."
    exit 1
fi

# Read the secrets
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

# Use these variables for the init.sql
sed -i "s/password_placeholder/$MYSQL_PASSWORD/g" /etc/mysql/init.sql
sed -i "s/\${MYSQL_USER}/$MYSQL_USER/g" /etc/mysql/init.sql

# Debug: Verify that sed replaced the placeholders correctly
echo "Verifying init.sql replacements:"
cat /etc/mysql/init.sql

# Clean up the MySQL data directory if present
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "Cleaning up existing MySQL data..."
    rm -rf /var/lib/mysql/*
fi

# Initialize the database if not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Starting MariaDB temporarily"
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    # Wait for MariaDB to start
    echo "Waiting for MariaDB to start..."
    until mysqladmin ping --silent; do
        sleep 1
    done

    # Set the root password explicitly
    echo "Setting root password"
    mysql -uroot <<EOF
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
        FLUSH PRIVILEGES;
EOF

    echo "Running init SQL script to set up database"
    mysql -uroot -p$MYSQL_PASSWORD < /etc/mysql/init.sql

    # Shut down MariaDB after initialization
    mysqladmin -uroot -p$MYSQL_PASSWORD shutdown
else
    echo "Database already initialized."
fi

# Start MariaDB normally
exec mysqld --user=mysql --datadir=/var/lib/mysql

