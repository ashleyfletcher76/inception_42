#!/bin/bash

cd /var/www/html

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# wait for MariaDB to be ready
while ! mysqladmin ping -hmariadb --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 2
done

WP_ADMIN_PASSWORD=$(cat /run/secrets/wo_admin_password)
WP_EDITOR_PASSWORD=$(cat /run/secrets/wo_editor_password)

# check if WordPress is already downloaded
if [ ! -f wp-config.php ]; then
	echo "Setting up WordPress for the first time..."

	# download WordPress core files
	./wp-cli.phar core download --allow-root

	# create wp-config.php using environment variables or secrets
	./wp-cli.phar config create --dbname=wordpress --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root

	# install WordPress with the main superuser admin
	./wp-cli.phar core install --url=localhost --title=inception --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

	# create an additional user with editor privileges
	./wp-cli.phar user create $WP_EDITOR editor@exampleemail.com --role=editor --user_pass=$WP_EDITOR_PASSWORD --allow-root

else
	echo "WordPress is already set up."
fi

php-fpm8.2 -F
