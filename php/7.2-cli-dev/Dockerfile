FROM php:7.2-cli-alpine

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS zlib-dev \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install -j$(nproc) zip pdo pdo_mysql \
    && apk del .build-deps \
    && curl https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --quiet
