FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
	mariadb-server && \
	rm -rf /var/lib/apt/lists/*

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/init.sql /etc/mysql/init.sql
COPY tools/script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh \
	&& mkdir -p /run/mysqld \
	&& chown mysql:mysql /run/mysqld

CMD ["/usr/local/bin/script.sh"]
