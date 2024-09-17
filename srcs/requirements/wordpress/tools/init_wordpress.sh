#!/bin/bash

# exits at first non-zero status
set -e

if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ]; then
    echo "ERROR: One or more required environment variables are not set. Exiting."
    exit 1
fi

cd /var/www/html

# wait for MariaDB
while ! mysqladmin ping -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 2
done

WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_EDITOR_PASSWORD=$(cat /run/secrets/wp_editor_password)
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)


if [ ! -f wp-config.php ]; then

	# download WordPress core files
	echo "Downloading word press core files..."
	curl -O https://wordpress.org/latest.tar.gz
	tar -xzf latest.tar.gz --strip-components=1
	echo "Download complete."

	# install WordPress with the superuser
	echo "Create wp config..."
	wp config create \
		--dbname=$MYSQL_DATABASE \
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
		--allow-root
	echo "Creating additional user complete."

	# set permissions
	chown -R www-data:www-data /var/www/html
	find /var/www/html -type d -exec chmod 755 {} \;
	find /var/www/html -type f -exec chmod 644 {} \;

	touch /var/www/html/.setup_done

else
	echo "WordPress is already set up."
fi

php-fpm7.4 -F