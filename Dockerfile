FROM debian:stretch-slim
MAINTAINER "sysadmin@kronostechnologies.com"

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install apt-transport-https curl gnupg2 -y \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
ADD etc/ /etc/
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
 && curl -s https://packages.sury.org/php/apt.gpg /etc/apt/trusted.gpg.d/php.gpg | apt-key add - \
 && curl -s https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

RUN apt-get update \
 && apt-get install -y \
 build-essential \
 debhelper \
 git \
 php5.6-cli \
 php5.6-xml \
 php5.6-zip \
 nasm \
 libpng-dev \
 nodejs \
 sudo \
 openssh-client \
 unzip \
 pkg-config \
 python \
 yarn \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN echo "Defaults env_keep=SSH_AUTH_SOCK" >> /etc/sudoers

RUN npm install -g grunt-cli bower
RUN curl -sL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY kbuild entrypoint.sh /usr/local/bin/

ENV DEBIAN_FRONTEND=''

WORKDIR /code

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
