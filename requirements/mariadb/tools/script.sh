#!/bin/bash
mysql_install_db --user=mysql --datadir=/var/lib/mysql
mysqld --user=mysql --init-file=/etc/mysql/init.sql
