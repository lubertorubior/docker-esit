FROM ubuntu:16.04
MAINTAINER Pedro Gonzalez "pgonyan@ull.edu.es"

# Install.
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y nginx \
    wget \
    vim

# install
RUN apt-get install -y \
    openssh-client \
    wget \
    nginx \
    curl \
    git \
    php \
    php-fpm \
    php7.0-ldap 


# add files
WORKDIR /bin
COPY start.sh /bin
RUN chmod a+x /bin/start.sh
# Copy our nginx config
RUN rm -Rf /etc/nginx/nginx.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf

# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
mkdir -p /etc/nginx/sites-enabled/ && \
mkdir -p /etc/nginx/ssl/ && \
rm -Rf /var/www/* && \
mkdir /var/www/html/
ADD conf/default /etc/nginx/sites-available/default
ADD conf/default-ssl /etc/nginx/sites-available/default-ssl
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
RUN rm -f /etc/nginx/sites-available/defaul
ADD conf/www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD conf/php.ini /etc/php/7.0/fpm/php.ini

# codigo
ADD src/ /var/www/html/

# Expose Ports
EXPOSE 80

USER root
# Define default command

CMD bash -C '/bin/start.sh';'bash'
