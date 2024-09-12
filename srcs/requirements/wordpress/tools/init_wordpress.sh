#!/bin/bash

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

if [ ! -f wp-config.php ]; then
	echo "Setting up WordPress for the first time..."

	# download WordPress core files
	./wp-cli.phar core download --allow-root

	# create wp-config.php
	./wp-cli.phar config create --dbname=wordpress --dbuser=$MYSQL_USER --dbpass=$(cat /run/secrets/mysql_password) --dbhost=mariadb --allow-root

	# install WordPress with the superuser
	./wp-cli.phar core install --url=localhost --title=inception --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

	# create an additional editor user
	./wp-cli.phar user create $WP_EDITOR $WP_EDITOR_EMAIL --role=editor --user_pass=$WP_EDITOR_PASSWORD --allow-root
	
	# Set permissions
	chown -R www-data:www-data /var/www/html
	chmod -R 755 /var/www/html

else
	echo "WordPress is already set up."
fi

php-fpm8.2 -F
