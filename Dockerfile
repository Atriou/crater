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
    && docker-php-ext-install pdo_mysql mbstring exif zip xml gd

# Installe Node.js 16
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Installe Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

COPY . .

RUN composer install --optimize-autoloader

RUN npm install --legacy-peer-deps && npm run build

RUN chown -R www-data:www-data /var/www

EXPOSE 8000

CMD php artisan migrate --seed && php artisan serve --host=0.0.0.0 --port=8000

