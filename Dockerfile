FROM php:5.6.40-apache
WORKDIR /var/www/html
COPY . /var/www/html/
ARG db_addr=127.0.0.1
ARG db_name=3wifi
ARG db_user=root
ARG db_pass=""
RUN a2enmod rewrite &&\
    docker-php-ext-install -j$(nproc) mysqli bcmath &&\
    docker-php-source delete &&\
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini &&\
    sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /usr/local/etc/php/php.ini &&\
    sed -i -e "s/display_errors = On/display_errors = Off/g" /usr/local/etc/php/php.ini &&\
    cp config.php-distr config.php &&\
    sed -i -e "s/define('DB_SERV', '.*');/define('DB_SERV', '${db_addr}');/g" config.php &&\
    sed -i -e "s/define('DB_NAME', '.*');/define('DB_NAME', '${db_name}');/g" config.php &&\
    sed -i -e "s/define('DB_USER', '.*');/define('DB_USER', '${db_user}');/g" config.php &&\
    sed -i -e "s/define('DB_PASS', '.*');/define('DB_PASS', '${db_pass}');/g" config.php && \
    apt-get update && \
    apt-get -y --no-install-recommends install supervisor &&\
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
CMD ["/usr/bin/supervisord", "-n", "-c", "supervisord.conf"]