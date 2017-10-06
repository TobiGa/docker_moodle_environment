FROM ubuntu:16.04
MAINTAINER Tobias Garske <tobias.garske@isb.bayern.de>

# no console input
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# install mysql server
RUN apt-get -y install mysql-server

# install apache server
RUN apt-get -y install apache2

# install php7
RUN	apt-get -y install pwgen python-setuptools curl git unzip php libapache2-mod-php postfix wget supervisor php-pgsql curl libcurl3 libcurl3-dev php-curl
RUN apt-get -y install php-xmlrpc php-intl php-mysql git-core php-xml php-mbstring php-zip php-soap cron
RUN phpenmod mysqli

# install phpmyadmin
RUN echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
RUN apt-get update
RUN apt-get -y install phpmyadmin

#install nodejs, npm and grunt
RUN apt-get -y install nodejs nodejs-legacy npm

#install ruby and compass
RUN apt-get -y install ruby ruby-compass
RUN gem install bootstrap-sass

#install vim, curl, git
RUN apt-get -y install vim curl git git-core

#add to get composer / behat ro run
RUN apt-get -y install php-gd libcurl3-dev php-curl php-xmlrpc php-intl php-mysql php-xml php-mbstring php-zip php-soap cron language-pack-en
RUN apt-get -y install php-xdebug openjdk-8-jre-headless xvfb

#install and delete firefox for dependencies
RUN apt-get -y install firefox
RUN apt-get purge -y firefox

#install composer
WORKDIR /var/www/html/moodle
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

#make ports accessible
EXPOSE 80 443 3306 4444

#add and execute start script
ADD ./data/start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
