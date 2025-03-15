FROM serversideup/php:8.4-fpm-nginx

WORKDIR /var/www/html/
COPY --chown=www-data:www-data  ./src ./
COPY --chown=www-data:www-data  ./src/.env.example ./.env

RUN composer install --optimize-autoloader --no-interaction --prefer-dist
