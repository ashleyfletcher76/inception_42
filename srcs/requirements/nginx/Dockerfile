From alpine: 3.18

# installs nginx wihtout extras and OpenSSL
RUN apk update && apk upgrade && \
    apk add --no-cache nginx openssl bash

# create the correct directories (store nginx config files, website files, SSL certs, stores its PID)
RUN mkdir -p /etc/nginx /var/www/html /etc/nginx/certs /run/nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/self-signed.key \
    -out /etc/nginx/certs/self-signed.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=yourdomain.com"

RUN chown -R nginx:nginx /var/www/html /etc/nginx /run/nginx

# uses port 443 to listen for nginx
EXPOSE 443

# makes sure nginx is the main process of the container
CMD ["nginx", "-g", "daemon off;"]