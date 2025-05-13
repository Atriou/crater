# Utilise une image PHP officielle avec extensions nécessaires
FROM php:8.1-fpm

# Installe dépendances système
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    npm \
    nodejs

# Installe Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définit le dossier de travail
WORKDIR /var/www

# Copie tout ton projet
COPY . .

# Installe les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Installe les dépendances front-end
RUN npm install && npm run build

# Donne les bonnes permissions
RUN chown -R www-data:www-data /var/www

# Expose le port
EXPOSE 8000

# Commande par défaut : serve Laravel
CMD php artisan migrate --seed && php artisan serve --host=0.0.0.0 --port=8000
