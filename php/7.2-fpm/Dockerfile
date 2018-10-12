FROM php:7.2-fpm-alpine

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS zlib-dev icu-dev libpng-dev \
    && apk add --no-cache icu-libs libpng \
    && docker-php-ext-install -j$(nproc) zip pdo pdo_mysql intl gd \
    && apk del .build-deps \
    && curl https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --quiet
