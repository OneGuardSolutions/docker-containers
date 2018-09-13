FROM php:7.2-fpm-alpine

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .build-deps \
    && curl https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --quiet

