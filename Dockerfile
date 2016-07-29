FROM exira/base:3.4.2

MAINTAINER exira.com <info@exira.com>

RUN mkdir -p /var/www/public_html/
WORKDIR /var/www/

ONBUILD COPY ./public_html/ /var/www/public_html/
ONBUILD COPY ./config/ /etc/nginx/sites/

VOLUME /var/www/
VOLUME /etc/nginx/sites/
