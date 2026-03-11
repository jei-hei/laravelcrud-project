# Use PHP-FPM as base image for Laravel web apps
FROM php:8.2-fpm

# Set working directory inside the container
WORKDIR /app

# Install system dependencies, PHP extensions and PHP itself
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    libpng-dev \
    libpq-dev \
    nodejs \
    npm \
    php-cli \
    php-fpm \
    php-mbstring \
    php-xml \
    php-pdo \
    php-pdo_pgsql \
    && docker-php-ext-install pdo pdo_pgsql zip \
    && apt-get clean

# Install Composer (PHP dependency manager)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files into the container
COPY . .

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Generate Laravel app key
RUN php artisan key:generate

# Install frontend dependencies and build assets using npm
RUN npm install
RUN npm run build

# Expose the port for the application
EXPOSE 8000

# Command to start Laravel app using php -S (built-in PHP server for development)
CMD sleep 5 && php artisan migrate --force && php -S 0.0.0.0:8000 -t public
