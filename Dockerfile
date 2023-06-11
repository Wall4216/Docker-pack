# Указываем базовый образ с PHP 8
FROM php:8.0-fpm

# Устанавливаем необходимые зависимости и инструменты
RUN apt-get update \
    && apt-get install -y \
        git \
        curl \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        zip \
        unzip

# Устанавливаем расширения PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Устанавливаем Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /var/www/html

# Копируем зависимости приложения
COPY composer.json .
COPY composer.lock .

# Устанавливаем зависимости приложения
RUN composer install --no-scripts --no-autoloader

# Копируем все остальные файлы приложения
COPY . .

# Запускаем скрипт сборки приложения
RUN composer dump-autoload
RUN php artisan config:cache

# Указываем порт, который будет открыт в контейнере
EXPOSE 9000

# Запускаем приложение
CMD ["php-fpm"]
