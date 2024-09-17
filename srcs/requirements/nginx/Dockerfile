FROM debian:bullseye

ARG DOMAIN_NAME

RUN apt update && apt upgrade -y && \
	apt install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

# generate self-signed SSL certificate
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/key.pem \
		-out /etc/nginx/ssl/cert.pem \
		-subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=${DOMAIN_NAME}"

# copy the custom NGINX configuration file to the sites-available directory
COPY default.conf /etc/nginx/sites-available/default

RUN sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" /etc/nginx/sites-available/default

# expose port 443 for HTTPS
EXPOSE 80 443

# daemon off stop its running in background
CMD ["nginx", "-g", "daemon off;"]

# because the other containers rely on the nginx if it stops the whole process stops, 
# so keeping it in the foreground means docker is prevented from stopping the nginx container