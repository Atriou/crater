# Utiliser une image toute prête avec PHP + Composer + Node.js déjà installés
FROM thecodingmachine/php:8.1-v4-cli-node14

# Définir le dossier de travail
WORKDIR /var/www

# Copier tout ton projet
COPY . .

# Installer les dépendances PHP (Laravel / Crater)
RUN composer install --optimize-autoloader

# Installer les dépendances front-end et builder
RUN npm install && npm run build

# Donner les bonnes permissions à l'application
RUN chown -R www-data:www-data /var/www

# Exposer le port HTTP
EXPOSE 8000

# Commande de démarrage de ton Crater
CMD php artisan migrate --seed && php artisan serve --host=0.0.0.0 --port=8000
