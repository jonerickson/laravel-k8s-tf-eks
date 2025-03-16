FROM serversideup/php:8.4-fpm-nginx as base

USER root

RUN apt-get update -y &&  \
    apt-get upgrade -y && \
    apt-get install -y nodejs npm && \
    apt-get autoremove

WORKDIR /var/www/html/

COPY ./src ./
COPY ./src/.env.example ./.env

RUN npm ci &&  \
    npm run build && \
    rm -rf node_modules

RUN chown -R www-data:www-data /var/www/html

USER www-data

FROM base as development

USER root

RUN composer install --optimize-autoloader --no-interaction --prefer-dist

USER www-data

FROM base as production

USER root

RUN composer install --optimize-autoloader --no-interaction --prefer-dist --no-dev

USER www-data

