#!/bin/bash

envsubst < "/mnt/init.sql.template" > "/mnt/init.sql"

mysql < /mnt/init.sql