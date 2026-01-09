ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
RUN \
  apk add --no-cache \
    apache2 \
    php84 \
    php84-apache2 \
    php84-opcache \
    php84-intl \
    php84-gd \
    php84-zip \
    php84-session \
    php84-openssl \
    php84-curl \
    php84-ctype \
    php84-pecl-apcu \
    php84-pecl-yaml \
    php84-dom \
    php84-mbstring \
    php84-simplexml \
    php84-xml \
    php84-fileinfo \
    php84-iconv \
    php84-exif \
    php84-pecl-memcache \
    php84-pecl-memcached \
    cronie \
    unzip

# Enable Apache Rewrite + Expires Module
RUN \
  sed -i '/#LoadModule rewrite_module/s/^#//' /etc/apache2/httpd.conf && \
  sed -i '/#LoadModule expires_module/s/^#//' /etc/apache2/httpd.conf && \
  printf '%s\n' \
    'ServerTokens Prod' \
    'ServerSignature Off' \
    'TraceEnable off' \
    'FileETag None' \
    'Header set X-Content-Type-Options: "nosniff"' \
  >> /etc/apache2/conf.d/security.conf

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
    echo 'upload_max_filesize=128M'; \
    echo 'post_max_size=128M'; \
    echo 'expose_php=off'; \
    } > /etc/php84/conf.d/php-recommended.ini

# Define Grav specific version of Grav or use latest stable
ARG GRAV_VERSION=latest

# Install Grav
WORKDIR /var/www
RUN curl -o grav-admin.zip -SL https://getgrav.org/download/core/grav-admin/${GRAV_VERSION} && \
    unzip grav-admin.zip && \
    mv grav-admin html && \
    rm grav-admin.zip && \
    cd html && \
    cp webserver-configs/htaccess.txt .htaccess && \
    mkdir /defaults && \
    mv user /defaults/ && \
    rm -r backup logs webserver-configs && \
    ln -s /data/user user && \
    ln -s /data/backup backup && \
    ln -s /data/logs logs

RUN \
    chown -R apache:apache /var/www && \
    sed -i 's#/var/www/localhost/htdocs#/var/www/html#' /etc/apache2/httpd.conf

# Create cron job for Grav maintenance scripts
RUN echo "* * * * * cd /var/www/html;/usr/bin/php bin/grav scheduler 1>> /dev/null 2>&1" \
    >> /etc/crontabs/root

# Copy data for add-on
COPY grav.conf /etc/apache2/conf.d/
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
# CMD ["sh", "-c", "crond && exec httpd -D FOREGROUND"]
