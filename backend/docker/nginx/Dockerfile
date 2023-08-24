FROM nginx:alpine

LABEL maintainer="Adio Azeez <adioadeyoriazeez@gmail.com>"

COPY nginx.conf /etc/nginx/

# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
        # Change application source from dl-cdn.alpinelinux.org to aliyun source
        sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
        ;fi

RUN apk update \
        && apk upgrade \
        && apk --update add logrotate \
        && apk add --no-cache openssl \
        && apk add --no-cache bash

RUN set -x ; \
        addgroup -g 82 -S www-data ; \
        adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

ARG PHP_UPSTREAM_CONTAINER=php_runtime
ARG PHP_UPSTREAM_PORT=9000

# Create 'messages' file used from 'logrotate'
RUN touch /var/log/messages

# Copy 'logrotate' config file  logrotate and Dockerfile are in the same directory
COPY logrotate /etc/logrotate.d/

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
        && rm /etc/nginx/conf.d/default.conf

ADD ssl.sh /opt/ssl.sh
RUN sed -i 's/\r//g' /opt/ssl.sh
RUN chmod +x /opt/ssl.sh
CMD ["/bin/bash", "/opt/ssl.sh"]

EXPOSE 80 443