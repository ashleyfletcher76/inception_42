FROM debian:bullseye

# install NGINX and OpenSSL
RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y nginx=1.18.* openssl && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=MO/L=KH/O=1337/OU=student/CN=asfletch.42.fr"

# create a non-root user and set ownership for security
RUN useradd -r -d /var/www -s /bin/false nginxuser && \
	chown -R nginxuser:nginxuser /etc/nginx /var/log/nginx /var/www /etc/ssl/private/nginx-selfsigned.key

# copy custom nginx config
COPY ./conf/nginx.conf /etc/nginx/nginx.template.conf

# expose ports for HTTPS
EXPOSE 443

# entrypoint script to substitute environment variables in config and start NGINX
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# switch to non-root user
USER nginxuser

# set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
