#!/bin/bash
cd /var/www/html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# download wordpress and create superuse
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
./wp-cli.phar core install --url=localhost --title=inception --admin_user=superuser --admin_password=potato --admin_email=superuser@exampleemail.com --allow-root

# second user
./wp-cli.phar user create editoruser editor@exampleemail.com --role=editor --user_pass=editorpassword --allow-root

php-fpm8.2 -F

