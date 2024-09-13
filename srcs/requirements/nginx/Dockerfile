FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
	nginx && \
	rm -rf /var/lib/apt/lists/*

# copy the custom NGINX configuration file to the sites-available directory
COPY default /etc/nginx/sites-available/.

# daemon off stop its running in background
CMD ["nginx", "-g", "daemon off;"]


# because the other containers rely on the nginx if it stops the whole process stops, 
# so keeping it in the foreground means docker is prevented from stopping the nginx container