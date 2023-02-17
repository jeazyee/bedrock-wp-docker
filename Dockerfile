FROM php:8.1-fpm

# Install required PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql

# Install stuff to make composer work (however this was not needed on my ARM Mac)
RUN apt-get install zip unzip git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory to the Bedrock project root
WORKDIR /var/www/html

# Copy the Bedrock files into the container
COPY . .

# Install the project dependencies with Composer
RUN composer install --no-interaction

# Set the ownership of the Bedrock files to the www-data user
RUN chown -R www-data:www-data /var/www/html

# Set the entrypoint to run the PHP-FPM process
CMD ["php-fpm"]