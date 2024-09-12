FROM debian:latest

RUN apt update && apt upgrade && apt install -y \
	php-fpm \
	php-mysqli \
	curl \
	mariadb-client

COPY www.conf /etc/php/8.2/fpm/pool.d/.

COPY ./tools/init_wordpress.sh .

RUN chmod +x init_wordpress.sh

CMD ["./init_wordpress.sh"]