# Use official PHP image
FROM php:8.2-cli

# Set working directory
WORKDIR /app

# 1️⃣ Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    libpng-dev \
    libpq-dev \
    nodejs \
    npm \
    && apt-get clean

# 2️⃣ Install required PHP extensions for Laravel
RUN docker-php-ext-install pdo pdo_pgsql mbstring zip

# 3️⃣ Copy project files
COPY . .

# 4️⃣ Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# 5️⃣ Install npm dependencies and build assets
RUN npm install && npm run build

# 6️⃣ Start Laravel server
CMD php artisan serve --host=0.0.0.0 --port=$PORT
