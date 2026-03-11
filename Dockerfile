# Use official PHP image with Apache for Laravel web apps
FROM php:8.2-apache

# Enable mod_rewrite for Apache (Laravel requires this)
RUN a2enmod rewrite

# Install system dependencies and PHP extensions
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
    php-mbstring \
    php-xml \
    php-pdo \
    php-pdo_pgsql \
    && docker-php-ext-install pdo pdo_pgsql zip \
    && apt-get clean

# Install Composer (PHP dependency manager)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files into the container
COPY . /var/www/html/

# Set the correct permissions
RUN chown -R www-data:www-data /var/www/html

# Install Laravel dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Generate Laravel app key
RUN php artisan key:generate

# Install frontend dependencies and build assets
RUN npm install
RUN npm run build

# Expose Apache default port (80)
EXPOSE 80

# Start Apache and Laravel app
CMD ["apache2-foreground"]
