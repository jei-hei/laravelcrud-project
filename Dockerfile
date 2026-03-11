# =============================
# 1️⃣ Base image
# =============================
FROM php:8.2-cli

# Set working directory
WORKDIR /app

# =============================
# 2️⃣ Install system dependencies
# =============================
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    libpng-dev \
    libpq-dev \
    libonig-dev \        # required by mbstring
    pkg-config \
    nodejs \
    npm \
    && apt-get clean

# =============================
# 3️⃣ Install PHP extensions required by Laravel
# =============================
RUN docker-php-ext-install pdo pdo_pgsql mbstring zip

# =============================
# 4️⃣ Copy project files
# =============================
COPY . .

# =============================
# 5️⃣ Install Composer
# =============================
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# =============================
# 6️⃣ Install npm dependencies and build assets (Vite)
# =============================
RUN npm install && npm run build

# =============================
# 7️⃣ Clear Laravel caches (optional but recommended)
# =============================
RUN php artisan config:clear \
    && php artisan cache:clear \
    && php artisan route:clear \
    && php artisan view:clear

# =============================
# 8️⃣ Start Laravel server
# =============================
CMD php artisan serve --host=0.0.0.0 --port=$PORT
