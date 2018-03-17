# --------------------------------------------------------------------
# Docker image for the support of the Lychee OSS Photo Album software
# --------------------------------------------------------------------
# Lychee is written in PHP and uses a local instance of MySQL and will
# use NGINX for the web based services. This image is beinfg used to support
# refactoring of the application to enable support as per the principles
# of a Cloud Native app
#
# This image is focused on only providing the Lychee web services as it
# is set with the expectation that mysql services will be provided as an external
# service.
# This also supports the evolving future state of the image to support a more scale-out
# CNA based data service such as Cassandra or MongoDB


# Using Ubuntu as base image initalluy, will look to shift to PhotonOS
FROM ubuntu:16.04
MAINTAINER David Lloyd <davidlloyd0@gmail.com>

# Get the Core installed
RUN apt-get update

# Lychee requires the following php extensions Installed (session, exif, mbstring, gd, mysqli, json, zip)
# Where lychee defaults to consuming local mysql services no mysql server instance will be located in this image
RUN apt-get -yq install git nginx imagemagick curl mysql-client \
                        php7.0-fpm php7.0-common php7.0-cli php7.0-mysqlnd \
                        php7.0-mysqli php-curl php7.0-json php7.0-zip php7.0-exif \
                        php7.0-mbstring php7.0-gd php7.0-exif

# Activate app in NGINX
COPY files/lychee-webapp /etc/nginx/sites-available
RUN rm /etc/nginx/sites-enabled/default && \
    rm /etc/nginx/sites-available/default && \
    ln -s /etc/nginx/sites-available/lychee-webapp /etc/nginx/sites-enabled && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

# Configure PHP
RUN sed -i -e "s/output_buffering\s*=\s*4096/output_buffering = Off/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 1G/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 1G/g" /etc/php/7.0/fpm/php.ini

# Get Lychee code
RUN mkdir -p /usr/share/webapps && \
    cd /usr/share/webapps && \
    git clone https://github.com/electerious/Lychee.git && \
    mv /usr/share/webapps/Lychee /usr/share/webapps/lychee

# Set entry point
COPY files/entry_point.sh /
RUN chmod 777 /entry_point.sh
ENTRYPOINT [ "/entry_point.sh" ]

# make it accessible
EXPOSE 80
VOLUME /config /photos

CMD [ "bash"]
