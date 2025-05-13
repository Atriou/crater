FROM php:8.1-fpm

# Installer dépendances système + extensions PHP
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libjpeg-dev \
    libfreetype6-dev \
    unzip

# Installer Node.js 14 correctement
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update && apt-get install -y nodejs

# Installer extensions PHP après Node.js
RUN docker-php-ext-install pdo_mysql mbstring exif zip xml gd

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir dossier de travail
WORKDIR /var/www

# Copier ton projet
COPY . .

# Installer dépendances PHP (Laravel/Crater)
RUN composer install --optimize-autoloader

# Installer dépendances front-end et builder assets
RUN npm install && npm run build

# Donner permissions correctes
RUN chown -R www-data:www-data /var/www

# Exposer port
EXPOSE 8000

# Lancer serveur Laravel
CMD php artisan migrate --seed && php artisan serve --host=0.0.0.0 --port=8000
