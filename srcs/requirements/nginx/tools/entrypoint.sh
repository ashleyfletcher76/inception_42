#!/bin/bash

envsubst '{DOMAIN_NAME} < /etc/nginx.template.conf > /etc/nginx/nginx.conf

# start nginx
nginx - g 'daemon off;''