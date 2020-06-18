#!/usr/bin/env bash
# start-server.sh

sed -i'' -e "s/%SERVER_PORT%/${SERVER_PORT}/g" /etc/nginx/sites-available/default
echo -e "~*~*~*~*~*~*~*~*~*~*~*~*~*\nDocker container listening on port ${SERVER_PORT}\n~*~*~*~*~*~*~*~*~*~*~*~*~*"
(cd /opt/app/vuln_django; gunicorn vuln_django.wsgi  --user www-data --bind 0.0.0.0:8010 --workers 3) &
nginx -g "daemon off;"
