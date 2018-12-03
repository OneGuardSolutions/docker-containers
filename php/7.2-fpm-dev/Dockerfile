FROM oneguard/php:7.2-fpm

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS zlib-dev libxml2-dev \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install -j$(nproc) soap \
    && apk del .build-deps \
    && echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo xdebug.remote_connect_back=1 >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
