FROM oneguard/php:7.2-cli

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS zlib-dev \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .build-deps
