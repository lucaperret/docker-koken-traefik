FROM php:7.2-apache-stretch

RUN apt-get update && apt-get install -y \
    libmagickwand-dev imagemagick \
    pwgen wget unzip ffmpeg libcurl4-gnutls-dev \
    libmcrypt4 libmcrypt-dev zlib1g zlib1g-dev \
    mcrypt ssl-cert \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install imagick-stable

## PHP Settings
# Install mcrypt https://stackoverflow.com/a/47673183/592024
RUN pecl install mcrypt-1.0.1 
RUN docker-php-ext-enable mcrypt

# Setup other php extensions
RUN docker-php-ext-install curl exif mysqli pdo_mysql zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN touch /usr/local/etc/php/conf.d/uploads.ini \
    && echo "upload_max_filesize = 150M;" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 155M;" >> /usr/local/etc/php/conf.d/uploads.ini

# Enable SSL for loopback connections
RUN a2ensite default-ssl
RUN a2enmod ssl
RUN make-ssl-cert generate-default-snakeoil --force-overwrite 
EXPOSE 443

# Enable mode rewrite
RUN a2enmod rewrite

VOLUME /var/www/html

RUN curl -fsSL -o /usr/local/src/Koken_Installer.zip \
        "https://s3.amazonaws.com/koken-installer/releases/Koken_Installer.zip" \
    && unzip -d /usr/local/src /usr/local/src/Koken_Installer.zip \
    && rm /usr/local/src/Koken_Installer.zip

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
