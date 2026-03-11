# Use PHP-FPM as base image for web apps
FROM php:8.2-fpm

# Set working directory inside the container
WORKDIR /app

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    curl \
    libpq-dev \
    nodejs npm \
    && docker-php-ext-install pdo pdo_pgsql zip \
    && apt-get clean

# Install Composer (PHP dependency manager)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Laravel project files to the container
COPY . .

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Generate Laravel app key
RUN php artisan key:generate

# Install frontend dependencies and build assets
RUN npm install
RUN npm run build

# Expose the port for the application
EXPOSE 8000

# Run migrations and serve the app
CMD sleep 5 && php artisan migrate --force && php -S 0.0.0.0:8000 -t public
