FROM ubuntu:16.04
MAINTAINER Nishchal Gautam <nishchal@crazy-factory.com>

VOLUME ["/var/www/html"]

RUN apt update && \
    apt install -y apache2 \
      php7.0 \
      libapache2-mod-php7.0 \
      curl \
      nodejs \
      npm \
      git \
      php7.0-curl \
      php7.0-dom \
      php7.0-mbstring \
      php7.0-zip \
      php7.0-mysql

RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | bash
RUN apt-get install php7.0-phalcon
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN echo "<?php phpinfo();" > /var/www/html/index.php

COPY apache_default /etc/apache2/sites-available/000-default.conf
COPY phpunit.phar /usr/share/php/PHPUnit/phpunit.phar
RUN chmod +x /usr/share/php/PHPUnit/phpunit.phar
COPY run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
RUN a2enmod rewrite
RUN service apache2 restart
EXPOSE 80
CMD ["/usr/local/bin/run"]
