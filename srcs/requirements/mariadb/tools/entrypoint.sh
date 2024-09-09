#!/bin/bash

service mysql start

if [ ! -d "/var/lib/mysql/wordpress" ]; then
	mysql < /docker-entrypoint-initdb.d/init.sql # create database if need be
fi

mysql_safe