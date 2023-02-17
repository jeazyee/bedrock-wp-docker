FROM php:8.1-fpm

# Install required PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql

# Enable execution of composer as root user
#ENV COMPOSER_ALLOW_SUPERUSER=1

# Install stuff to make composer work (however this was not needed on my ARM Mac)
RUN apt-get update && apt-get install -y zip unzip git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory to the Bedrock project root
WORKDIR /var/www/html

# Copy the Bedrock files into the container
COPY . /var/www/html

# Set the ownership of the Bedrock files to the www-data user
RUN chown -R www-data:www-data /var/www/html

# Install the project dependencies with Composer
RUN su -s /bin/bash -c "composer install --working-dir=/var/www/html" -g www-data www-data

# Set the entrypoint to run the PHP-FPM process
CMD ["php-fpm"]