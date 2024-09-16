#!/bin/bash

# exits at first non-zero status
set -e

cd /var/www/html

# download wp-cli.phar if need be
if [ ! -f wp-cli.phar ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
fi

# wait for MariaDB
while ! mysqladmin ping -hmariadb --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 2
done

WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_EDITOR_PASSWORD=$(cat /run/secrets/wp_editor_password)
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

echo "MYSQL_USER is: $MYSQL_USER"
echo "MYSQL_PASSWORD is: $MYSQL_PASSWORD"


if [ ! -f wp-config.php ]; then
	echo "Setting up WordPress for the first time..."

	# download WordPress core files
	echo "Downloading word press core files..."
	./wp-cli.phar core download --allow-root
	echo "Download wordpress complete."

	# create wp-config.php
	echo "Creating wp-config..."
	./wp-cli.phar config create --dbname=wordpress --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root
	echo "Creating wp-config complete."

	# install WordPress with the superuser
	echo "Instaliing wordpress..."
	./wp-cli.phar core install --url=localhost --title=inception --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
	echo "Instaliing wordpress complete"

	# create an additional editor user
	./wp-cli.phar user create $WP_EDITOR $WP_EDITOR_EMAIL --role=editor --user_pass=$WP_EDITOR_PASSWORD --allow-root
	
	# Set permissions
	chown -R www-data:www-data /var/www/html
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