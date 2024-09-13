FROM debian:bullseye

# upgrade package lists and install mariadb server
RUN apt update && apt upgrade -y && apt install -y \
	mariadb-server && \
	rm -rf /var/lib/apt/lists/*

# copy the scripts and custom config into the docker container
COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/init.sql /etc/mysql/init.sql
COPY tools/script.sh /usr/local/bin/

# make start up script executable and create the correct directories with right permissions
RUN chmod +x /usr/local/bin/script.sh \
	&& mkdir -p /run/mysqld \
	&& chown mysql:mysql /run/mysqld

# custom entrypoint for container
CMD ["/usr/local/bin/script.sh"]
