FROM ubuntu:16.04

MAINTAINER "Jackson Web Team" <webadmin@jacksonfurnind.com>

RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    nginx \
    git \
    curl \
    nodejs \
    npm \
    ruby \
    libnotify-bin \
    php7.0-fpm \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-odbc \
    php7.0-curl \
    php7.0-cli \
    php7.0-gd \
    php7.0-xml

RUN apt-get -y autoremove && rm -rf /var/lib/apt/lists/*


# Configure PHP FPM
ENV PHP_INI_DIR   /etc/php/7.0/fpm
ENV PHP_INI	  ${PHP_INI_DIR}/php.ini

RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf 
RUN sed -i s'/listen = \/run\/php\/php7.0-fpm.sock/listen = 127.0.0.1:9000/' /etc/php/7.0/fpm/pool.d/www.conf 
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" $PHP_INI 
RUN sed -i "s/display_errors = Off/display_errors = On/" $PHP_INI
RUN sed -i "s/;date.timezone =/date.timezone = America\/New_York/" $PHP_INI
RUN phpenmod mcrypt


EXPOSE 80

CMD service php7.0-fpm start && nginx
