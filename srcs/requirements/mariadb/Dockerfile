FROM alpine:latest

# install bash, curl, gnupg, and mariadb directly from alpines package manager
RUN apk add --no-cache bash curl gnupg mariadb mariadb-client

# copy config files
COPY ./conf/maria.conf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/init.sql /docker-entrypoint-initdb.d/init.sql
COPY ./tools/entrypoint.sh /entrypoint.sh

# entryponint needs to be executable
RUN chmod +x /entrypoint.sh

# mariaDB default port
EXPOSE 3306

# define the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
