FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libjpeg-dev \
    libfreetype6-dev \
    unzip \
    npm \
    nodejs \
    && docker-php-ext-install pdo_mysql mbstring exif zip xml gd

# Installe Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

COPY . .

# Installe dépendances PHP/Laravel
RUN composer install --optimize-autoloader

# Installe dépendances front-end
RUN npm install && npm run build

# Donne les bonnes permissions
RUN chown -R www-data:www-data /var/www

EXPOSE 8000

# Commande pour démarrer
CMD php artisan migrate --seed && php artisan serve --host=0.0.0.0 --port=8000
