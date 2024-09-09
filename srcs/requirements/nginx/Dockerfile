FROM debian:bullseye

# install NGINX and OpenSSL
RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y nginx openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=MO/L=KH/O=1337/OU=student/CN=asfletch.42.fr"


COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# makes sure nginx is the main process of the container
CMD ["nginx", "-g", "daemon off;"]