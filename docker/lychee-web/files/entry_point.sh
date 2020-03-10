#! /bin/bash

# Setup directories and symlinks for lychee so that root level folders used for data
[ ! -d /config/lychee ] && \
    mkdir -p /config/lychee
[ ! -d /var/www ] && \
    mkdir -p /var/www
[ ! -L /var/www/lychee ] && \
	ln -s /usr/share/webapps/lychee /var/www/lychee
[ -d /usr/share/webapps/lychee/uploads ] && \
	rm -rf /usr/share/webapps/lychee/uploads
[ ! -L /usr/share/webapps/lychee/uploads ] && \
	ln -s /photos /usr/share/webapps/lychee/uploads
[ -d /usr/share/webapps/lychee/data ] && \
	rm -rf /usr/share/webapps/lychee/data
[ ! -L /usr/share/webapps/lychee/data ]
	ln -s /config/lychee /usr/share/webapps/lychee/data


# create photo store folder structure
for image_index in {big,import,medium,thumb}; 
do
   if [ ! -f /photos/${image_index}/index.html ]; then
      mkdir -p /photos/${image_index}
      : > /photos/${image_index}/index.html
   fi
done


# create user config for Lychee if not present
[ ! -e /config/lychee/user.ini ] && \
	echo max_execution_time = 200 > /config/lychee/user.ini && \
    echo post_max_size = 200M >> /config/lychee/user.ini && \
    echo upload_max_size = 200M >> /config/lychee/user.ini && \
    echo upload_max_filesize = 20M >> /config/lychee/user.ini && \
    echo max_file_uploads = 200 >> /config/lychee/user.ini


# Create Lychee database access config file
[ ! -e /config/lychee/config.php ] && \
    echo "<?php" > /config/lychee/config.php && \
    echo "// Database configuration" >> /config/lychee/config.php && \
    echo \$dbHost = \'$DB_HOST\'\; >> /config/lychee/config.php && \
    echo \$dbUser = \'$DB_USER\'\; >> /config/lychee/config.php && \
    echo \$dbPassword = \'$DB_PASSWORD\'\; >> /config/lychee/config.php && \
    echo \$dbName = \'$DB_NAME\'\; >> /config/lychee/config.php && \
    echo \$dbTablePrefix = \'$DB_PREFIX\'\; >> /config/lychee/config.php && \
    echo "?>" >> /config/lychee/config.php

# Set variables for web application
[ -e /etc/php/7.4/fpm/pool.d/www.conf ] && \
    echo "env[DB_USER] = $DB_USER" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[DB_PASSWORD] = $DB_PASSWORD" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[DB_HOST] = $DB_HOST" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "env[DB_NAME] = $DB_NAME" >> /etc/php/7.4/fpm/pool.d/www.conf


# permissions
chown -R root:root \
	/config \
	/photos \
	/usr/share/webapps/lychee \
	/var/www/lychee

chmod -R 777 /config /photos

# Get PHP started as installs stopped
service php7.4-fpm start

# Get nginx service started as installs stopped
service nginx start

exec "$@"
