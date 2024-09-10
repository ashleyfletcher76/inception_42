FROM debian:latest

RUN apt update && apt upgrade -y && apt install -y mariadb-server

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/init-db.sh /usr/local/bin/init-db.sh
COPY tools/init.sql.template /mnt/init.sql.template

RUN chmod +x /usr/local/bin/init-db.sh

CMD ["mysqld_safe"]
