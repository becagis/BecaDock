FROM nginx

LABEL maintainer="Truong Thanh Tung <ttungbmt@gmail.com>"

ARG HTTP_HOST=localhost
ENV HTTP_HOST ${HTTP_HOST}

ARG HTTP_PORT=90
ENV HTTP_PORT ${HTTP_PORT}

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ENV PHP_UPSTREAM_CONTAINER ${PHP_UPSTREAM_CONTAINER}

ARG PHP_UPSTREAM_PORT=9000
ENV PHP_UPSTREAM_PORT ${PHP_UPSTREAM_PORT}

WORKDIR /etc/nginx

RUN apt-get update -yqq \
    && apt-get upgrade -y \
    && apt-get install -y logrotate openssl inotify-tools bash \
          iputils-ping telnet wget \
          vim

# Create 'messages' file used from 'logrotate'
RUN touch /var/log/messages

# Copy 'logrotate' config file
COPY logrotate/nginx /etc/logrotate.d/


ADD nginx.conf.envsubst ./
ADD ./sites ./sites-available

RUN rm /etc/nginx/conf.d/default.conf

ADD docker-autoreload.sh docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN chmod +x /docker-autoreload.sh
RUN chmod +x /docker-entrypoint.sh

CMD ["nginx", "-g", "daemon off;"]
