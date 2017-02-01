#!/bin/sh

docker build -t oldskool73/php-fpm:7.0 -f Dockerfile .
docker push oldskool73/php-fpm
