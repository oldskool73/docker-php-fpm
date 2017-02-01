FROM php:5.6-fpm

## Install required extensions

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev

RUN docker-php-ext-install mcrypt

RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install pdo_pgsql

RUN docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 && \
docker-php-ext-install gd

## Set Timezone

ARG TZ=Australia/Sydney
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

## Install Opcache (optional)

ARG INSTALL_OPCACHE=false
RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache && \
    docker-php-ext-enable opcache \
;fi
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini


## Install Configs

COPY laravel.ini /usr/local/etc/php/conf.d
COPY laravel.pool.conf /usr/local/etc/php-fpm.d/

## Cleanup

RUN rm -r /var/lib/apt/lists/*

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
