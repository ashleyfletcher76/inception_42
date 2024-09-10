#!/bin/bash
cd /var/www/html

# Download the WordPress CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# Download WordPress core files
./wp-cli.phar core download --allow-root

# Create wp-config.php using environment variables from the .env file
./wp-cli.phar config create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=mariadb --allow-root

# Install WordPress using environment variables for admin credentials
./wp-cli.phar core install --url=localhost --title=inception --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --allow-root

# Start PHP-FPM in the foreground
php-fpm8.2 -F
