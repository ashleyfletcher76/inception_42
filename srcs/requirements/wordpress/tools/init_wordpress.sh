#!/bin/bash

# exits at first non-zero status
set -e

cd /var/www/html

# wait for MariaDB
while ! mysqladmin ping -hmariadb --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 2
done

WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_EDITOR_PASSWORD=$(cat /run/secrets/wp_editor_password)
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)


if [ ! -f wp-config.php ]; then
	echo "Setting up WordPress for the first time..."

	# download WordPress core files
	echo "Downloading word press core files..."
	if [ ! -f wp-config.php ]; then
		curl -O https://wordpress.org/latest.tar.gz
	fi
	tar -xzf latest.tar.gz --strip-components=1

	echo "Download wordpress complete."

	# create wp-config.php
	echo "Creating wp-config..."
	./wp-cli.phar config create --dbname=wordpress --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root
	echo "Creating wp-config complete."

	# install WordPress with the superuser
	echo "Create wp config..."
	wp config create \
		--dbname=wordpress \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost=mariadb \
		--allow-root
	echo "wp config complete"

	echo "Installing wordpress"
	wp core install \
		--url="$DOMAIN_NAME" \
		--title="Inception" \
		--admin_user="$WP_ADMIN" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root
	echo "Installing wordpress complete."

	# create an additional editor user
	echo "Creating additional user"
	wp user create \
		"$WP_EDITOR" \
		"$WP_EDITOR_EMAIL" \
		--role=editor \
		--user_pass="$WP_EDITOR_PASSWORD" \
		--alow-root
	echo "Creating additional user complete."

	# set permissions
	chown -R www-data:www-data /var/www/html
	find /var/www/html -type d -exec chmod 755 {} \;
	find /var/www/html -type f -exec chmod 644 {} \;
	chmod -R 755 /var/www/html

	touch /var/www/html/.setup_done

else
	echo "WordPress is already set up."
fi

if [ -f wp-cli.phar ]; then
	echo "Cleaning up .phar file"
	rm wp-cli.phar
fi

php-fpm7.4 -F