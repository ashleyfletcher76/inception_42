FROM debian:bullseye

# update and install PHP, PHP-FPM, and additional necessary extensions
RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y php-fpm php-mysql php-gd php-xml php-mbstring php-zip curl
	apt-get clean && rm -rf /var/lib/apt/lists/*

# get the latest WordPress version
RUN curl -O https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz -C /var/www/html --strip-components=1 && \
	rm latest.tar.gz

# change ownership of the WordPress files to server user
RUN chown -R www-data:www-data /var/www/html

# expose port 9000
EXPOSE 9000

# copy WordPress configuration file
COPY ./conf/wp-config.php /var/www/html/wp-config.php

# start PHP-FPM in the foreground
CMD ["php-fpm", "-F"]
