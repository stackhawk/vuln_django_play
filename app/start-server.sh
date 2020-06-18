#!/usr/bin/env bash
# start-server.sh

sed -i'' -e "s/%SERVER_PORT%/${SERVER_PORT}/g" /etc/nginx/sites-available/default

(cd /opt/app/vuln_django; gunicorn vuln_django.wsgi  --user www-data --bind 0.0.0.0:${SERVER_PORT} --workers 3) &
nginx -g "daemon off;"
