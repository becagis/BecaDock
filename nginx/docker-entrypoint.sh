#!/bin/sh

# Exit script in case of error
set -e

echo "-----------------------------------------------------"
echo "STARTING NGINX ENTRYPOINT ---------------------------"
date

if [ -d /etc/nginx/ssl ] && [ ! -f /etc/nginx/ssl/default.crt ]; then
    echo "Generate SSL key"
    mkdir -p /etc/nginx/ssl
    openssl genrsa -out "/etc/nginx/ssl/default.key" 2048
    openssl req -new -key "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.csr" -subj "/CN=default/O=default/C=UK"
    openssl x509 -req -days 365 -in "/etc/nginx/ssl/default.csr" -signkey "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.crt"
    chmod 644 /etc/nginx/ssl/default.key
fi

echo "Replacing environement variables"
envsubst '$HTTP_PORT $HTTPS_PORT $HTTP_HOST $HTTPS_HOST $RESOLVER' < /etc/nginx/nginx.conf.envsubst > /etc/nginx/nginx.conf
for f in /etc/nginx/sites-available/*.envsubst; do envsubst '$HTTP_PORT $HTTPS_PORT $HTTP_HOST $HTTPS_HOST $PHP_UPSTREAM_CONTAINER $PHP_UPSTREAM_PORT' < $f > "/etc/nginx/sites-available/$(basename $f .envsubst)"; done

echo "Loading nginx autoreloader"
##sh /docker-autoreload.sh &

echo "-----------------------------------------------------"
echo "FINISHED NGINX ENTRYPOINT ---------------------------"
echo "-----------------------------------------------------"

# Run the CMD
exec "$@"
