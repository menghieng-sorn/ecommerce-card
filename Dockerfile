# ==========================================
# Stage 1: Install Composer dependencies
# ==========================================
FROM composer:2 AS build-stage

WORKDIR /app

# Copy Composer files first for Docker cache
COPY composer.json composer.lock ./

# Install Laravel dependencies (production only)
RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader \
    --no-scripts

# Copy Laravel application source
COPY . .

# Re-run composer to trigger post-autoload scripts (package discovery) without dev deps
RUN composer dump-autoload --optimize --no-dev --classmap-authoritative


# ==========================================
# Stage 2: Production container (Nginx + PHP-FPM)
# ==========================================
FROM php:8.3-fpm-alpine

WORKDIR /var/www/html

# Install runtime packages + build deps for PHP extensions
RUN apk add --no-cache \
        icu-dev \
        libzip-dev \
        oniguruma-dev \
        mysql-client \
        nginx \
        supervisor \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        intl \
        zip \
        bcmath \
        opcache \
    && apk del .build-deps || true

# Production PHP configuration
RUN { \
        echo 'memory_limit=256M'; \
        echo 'upload_max_filesize=100M'; \
        echo 'post_max_size=100M'; \
        echo 'max_execution_time=60'; \
        echo 'expose_php=Off'; \
        echo 'date.timezone=UTC'; \
    } > /usr/local/etc/php/conf.d/zz-production.ini

# OPcache configuration tuned for production
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.enable_cli=0'; \
        echo 'opcache.memory_consumption=192'; \
        echo 'opcache.interned_strings_buffer=16'; \
        echo 'opcache.max_accelerated_files=20000'; \
        echo 'opcache.validate_timestamps=0'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.fast_shutdown=1'; \
    } > /usr/local/etc/php/conf.d/zz-opcache.ini

# PHP-FPM pool: listen on TCP so Nginx can reach it
RUN { \
        echo '[www]'; \
        echo 'listen = 127.0.0.1:9000'; \
        echo 'pm = dynamic'; \
        echo 'pm.max_children = 20'; \
        echo 'pm.start_servers = 4'; \
        echo 'pm.min_spare_servers = 2'; \
        echo 'pm.max_spare_servers = 8'; \
        echo 'pm.max_requests = 500'; \
        echo 'catch_workers_output = yes'; \
        echo 'access.log = /dev/stdout'; \
        echo 'access.format = "%R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%%"'; \
    } > /usr/local/etc/php-fpm.d/zz-www.conf

# Copy application from build stage
COPY --from=build-stage /app /var/www/html

# Copy Nginx + Supervisor configuration
COPY docker/nginx.conf        /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf  /etc/supervisord.conf

# Laravel storage + cache ownership
RUN chown -R www-data:www-data \
        /var/www/html/storage \
        /var/www/html/bootstrap/cache

# Pre-create runtime directories
RUN mkdir -p /var/www/html/storage/framework/cache/data \
             /var/www/html/storage/framework/sessions \
             /var/www/html/storage/framework/views \
             /var/www/html/storage/logs \
             /run/nginx \
             /var/log/supervisor \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

# Healthcheck via Nginx (PHP-FPM may not respond directly)
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://127.0.0.1/healthcheck || exit 1

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
