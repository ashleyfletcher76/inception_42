#!/bin/bash
# Load passwords from secrets
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)
MYSQL_ADMIN_PASSWORD=$(cat /run/secrets/mysql_admin_password)

# Substituting environment variables into SQL commands
envsubst < "/mnt/init.sql.template" > "/mnt/init.sql"
mysql < "/mnt/init.sql"
