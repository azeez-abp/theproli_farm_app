#!/bin/bash

if [ ! -f /etc/nginx/ssl/default.crt ]; then
    if [ ! -d /etc/nginx/ssl ];then
        mkdir /etc/nginx/ssl
    fi
    openssl genrsa -out "/etc/nginx/ssl/default.key" 2048
    openssl req -new -key "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.csr" -subj "/CN=default/O=default/C=NG"
    openssl x509 -req -days 365 -in "/etc/nginx/ssl/default.csr" -signkey "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.crt"
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx