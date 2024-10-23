FROM php:8.2.11-fpm

# Install Composer
RUN cd /tmp \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# Install all required PHP extensions and useful tools in a single RUN statement
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libpq-dev \
    apt-utils \
    nano \
    wget \
    dialog \
    vim \
    build-essential \
    git \
    curl \
    libcurl4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    libbz2-dev \
    locales \
    libmcrypt-dev \
    libicu-dev \
    libonig-dev \
    nodejs \
    npm \
    libxml2-dev \
    supervisor \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_mysql gd pdo_pgsql pgsql exif mbstring pcntl bcmath zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up Supervisor configuration
COPY ./docker/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# Set the working directory
WORKDIR /var/www
COPY . .

# Run composer install
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Ensure the bootstrap/cache and storage directories exist and are writable
RUN mkdir -p /var/www/bootstrap/cache /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache /var/www/storage

# Expose the port
EXPOSE 9000

# Define entry point to run Supervisor and PHP-FPM
CMD ["/usr/bin/supervisord", "-n"]
