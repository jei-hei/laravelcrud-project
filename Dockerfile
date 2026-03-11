# Use PHP-FPM image (preferred for web applications like Laravel)
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
    && docker-php-ext-install pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files to the working directory
COPY . .

# Install Laravel PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Generate app key for Laravel
RUN php artisan key:generate

# Install frontend dependencies and build assets
RUN npm install
RUN npm run build

# Expose the port that Laravel will run on (usually 8000 or 10000, for Render we can use 8000)
EXPOSE 8000

# Startup: wait a few seconds, run migrations, then serve the app
CMD sleep 5 && php artisan migrate --force && php -S 0.0.0.0:8000 -t public
