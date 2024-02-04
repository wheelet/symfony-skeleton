# Use the official PHP image with the version that matches your Symfony project requirements
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install pdo pdo_mysql zip intl gd mbstring exif pcntl bcmath soap

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/symfony

# Set up user for container security
RUN useradd -G www-data,root -u 1000 -d /home/symfony symfony
RUN mkdir -p /home/symfony/.composer && \
    chown -R symfony:symfony /home/symfony

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
