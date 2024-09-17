FROM debian:bullseye

# update package lists, upgrade installed packages, and install necessary dependencies
# - php7.4-fpm: PHP FastCGI Process Manager, needed for running PHP applications
# - php7.4-mysqli: MySQLi extension for interacting with MariaDB/MySQL databases
# - mariadb-client: MySQL client tools, allowing PHP to connect to the MariaDB database
# after installation, remove cached package lists to reduce the image size
RUN apt update && apt upgrade -y && apt install -y \
	php7.4-fpm \
	php7.4-mysql \
	php7.4-curl \
	php7.4-xml \
	php7.4-mbstring \
	php7.4-gd \
	php7.4-zip \
	curl \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

# Install wp-cli globally
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x /usr/local/bin/wp

# this file customizes PHP-FPM's behavior, such as listening on a specific socket
COPY www.conf /etc/php/7.4/fpm/pool.d/.

COPY ./tools/init_wordpress.sh .

RUN chmod +x init_wordpress.sh

CMD ["./init_wordpress.sh"]
