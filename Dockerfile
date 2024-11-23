FROM php:8.2.11-fpm

# Install Composer
RUN cd /tmp \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

<<<<<<< HEAD
# Install all required PHP extensions and useful tools in a single RUN statement
=======


>>>>>>> Payment12k
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
    && docker-php-ext-install pdo pdo_pgsql pgsql exif gd

    # Install PHP extensions
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

    RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# Set the working directory
WORKDIR /var/www
COPY . .

# Run composer install
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Run composer install
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Run Permissions
RUN mkdir -p /var/www/bootstrap/cache /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache /var/www/storage


COPY ./docker-compose/supervisor/supervisor.conf /etc/supervisor/conf.d/supervisor.conf


RUN npm install


# Ensure the bootstrap/cache and storage directories exist and are writable
RUN mkdir -p /var/www/bootstrap/cache /var/www/storage \
    && chown -R www-data:www-data /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache /var/www/storage



# Expose the port
EXPOSE 9000
CMD ["php-fpm"]
