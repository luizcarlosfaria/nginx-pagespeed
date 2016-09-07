#!/bin/bash 
set -e 

if [ ! -f /etc/nginx/nginx.conf ]; then 
	cp /_config_backup/. /etc/nginx -R 
fi 

exec "$@"



