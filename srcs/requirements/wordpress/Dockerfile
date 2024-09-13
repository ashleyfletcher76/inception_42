FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
	php7.4-fpm \
	php7.4-mysqli \
	curl \
	mariadb-client && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

COPY www.conf /etc/php/7.4/fpm/pool.d/.

COPY ./tools/init_wordpress.sh .

RUN chmod +x init_wordpress.sh

CMD ["./init_wordpress.sh"]
