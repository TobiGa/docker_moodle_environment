#!/bin/bash

#start mysql
service mysql start

#set permissions
mkdir /var/www/html/moodle/behat_testoutput
chown -R www-data:www-data /var/www/
chmod -R 775 /var/www/

#if config.php
if [ -f /var/www/html/moodle/config.php ]; then

  #if no behat config
  if ! grep -q "behat_dataroot" /var/www/html/moodle/config.php ; then

     sed -i '/$CFG->directorypermissions = 0777;/a \
     $CFG->phpunit_prefix = "phpu_"; \
     $CFG->phpunit_dataroot = "/var/www/phpu_moodledata"; \
     $CFG->behat_prefix = "bht_"; \
     $CFG->behat_dataroot = "/var/www/behat_moodledata"; \
     $CFG->behat_wwwroot = "http://127.0.0.1/moodle"; \
     //$CFG->theme = "boost";' /var/www/html/moodle/config.php
  fi

fi

#set root pw
mysqladmin -u root password pw_root

  mysql -u root -ppw_root -e "SET GLOBAL innodb_file_per_table = ON;"
  mysql -u root -ppw_root -e "SET GLOBAL innodb_large_prefix = ON;"
  mysql -u root -ppw_root -e "SET GLOBAL innodb_file_format = Barracuda;"


#phpmyadmin apache.conf extension exists?
if ! grep -q "phpmyadmin" /etc/apache2/apache2.conf ; then
  #add phpadmin/apache.conf to apache.conf to make phpmyadmin work
  echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
fi  

#if node is version 0.10 from first ubuntu install
if node --version | grep -q 0.10.25; then
  echo "update node, install npm and grunt"  

  npm cache clean -f
  npm install -g n
  n stable

  #install node dependencies and grunt
  npm install npm@latest -g

  npm install npm@latest -g
  npm install -g grunt-cli

  echo "run npm install in /var/www/html/moodle"  
  cd /var/www/html/moodle
  npm install --only=dev
fi

#install firefox 47
if [ ! -d "/opt/firefox47" ]; then
  cd /external
  tar -xjf firefox-47.0.1.tar.bz2
  mv firefox /opt/firefox47
  ln -s /opt/firefox47/firefox /usr/bin/firefox 
fi

#update moodle db and init behat
php /var/www/html/moodle/admin/cli/upgrade.php --non-interactive
php /var/www/html/moodle/admin/tool/behat/cli/init.php

#phpmyadmin apache.conf extension exists?
if ! grep -q "phpmyadmin" /etc/apache2/apache2.conf ; then
  #add phpadmin/apache.conf to apache.conf to make phpmyadmin work
  echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
fi  
#if process needs to be killed
#pkill -9 -P 486

#start apache
#/usr/sbin/apache2ctl -D FOREGROUND - to start in foreground 
/usr/sbin/apache2ctl start

#start selenium server
xvfb-run java -jar /external/selenium-server-standalone-2.53.1.jar
