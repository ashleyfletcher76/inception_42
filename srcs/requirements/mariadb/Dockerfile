FROM debian:latest

RUN apt update && apt upgrade -y && apt install -y \
	mariadb-server

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY tools/init.sql /etc/mysql/init.sql
COPY tools/script.sh .

RUN mkdir /run/mysqld && chmod +x script.sh

CMD ["./script.sh"]
