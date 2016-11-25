FROM ubuntu:16.04
MAINTAINER Nishchal Gautam <nishchal@crazy-factory.com>

VOLUME ["/var/www/html"]

RUN apt-get update && \
    apt-get install -y
      apache2 \
      php7.0 \
      libapache2-mod-php7.0 \
      curl \
      nodejs \
      npm \
      git \
      php7.0-curl \
      php7.0-dom \
      php7.0-mbstring \
      php7.0-zip

RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | bash
RUN sudo apt-get install php7.0-phalcon
RUN service apache2 restart
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN echo "<?php phpinfo();" > /var/www/html/index.php

COPY apache_default /etc/apache2/sites-available/000-default.conf
COPY run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
RUN a2enmod rewrite

EXPOSE 80
CMD ["/usr/local/bin/run"]
