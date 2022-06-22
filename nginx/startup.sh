#!/bin/bash

if [ -d /etc/nginx/ssl ] && [ ! -f /etc/nginx/ssl/default.crt ]; then
    mkdir -p /etc/nginx/ssl
    openssl genrsa -out "/etc/nginx/ssl/default.key" 2048
    openssl req -new -key "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.csr" -subj "/CN=default/O=default/C=UK"
    openssl x509 -req -days 365 -in "/etc/nginx/ssl/default.csr" -signkey "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.crt"
    chmod 644 /etc/nginx/ssl/default.key
fi

# Replacing environement variables
envsubst '$PHP_UPSTREAM_CONTAINER $PHP_UPSTREAM_PORT' < /etc/nginx/conf.d/upstream.conf.envsubst > /etc/nginx/conf.d/upstream.conf
for f in /etc/nginx/sites-available/*.envsubst; do envsubst '$HTTP_PORT $HTTPS_PORT $HTTP_HOST $HTTPS_HOST' < $f > "/etc/nginx/sites-available/$(basename $f .envsubst)"; done

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
