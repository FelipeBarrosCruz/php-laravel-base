FROM escritha/php-base as php

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install nginx and php-fpm
RUN add-apt-repository -y ppa:nginx/stable
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    git \
    nginx \
    php7.4-fpm \
    php7.4-cli \
    php7.4-json \
    php7.4-curl \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-sqlite \
    php7.4-xml \
    php7.4-zip \
    php7.4-soap \
    php7.4-imagick \
    php7.4-gd \
    php7.4-intl

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /var/log/php7.4-fpm.log

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename /usr/local/bin/composer

# Set up nginx
ADD .docker/app/nginx/nginx.conf /etc/nginx/nginx.conf
ADD .docker/app/nginx/sites-enabled/default /etc/nginx/sites-enabled/default
ADD .docker/app/logrotate.d/nginx /etc/logrotate.d/nginx

# Set up php-fpm
ADD .docker/app/php-fpm/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
ADD .docker/app/php-fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Set up supervisor
ADD .docker/app/supervisor/conf.d/nginx-php.conf /etc/supervisor/conf.d/nginx-php.conf
ADD .docker/app/init.sh /opt/init.sh

# Clean image
RUN apt-get autoclean && \
  apt-get autoremove --purge -y && \
  rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/app

ADD /src /var/app/

ADD /src/composer.* ./

RUN chown -R www-data.www-data /var/app/

RUN chmod -R 775 /var/app/storage /var/app/bootstrap/cache

# Adding crontab to the appropriate location
ADD crontab /etc/cron.d/default

# Giving permission to crontab file
RUN chmod 0644 /etc/cron.d/default

# Running crontab
RUN crontab /etc/cron.d/default

ADD /scripts /etc/scripts

EXPOSE 80

CMD ["bash", "/opt/init.sh"]
