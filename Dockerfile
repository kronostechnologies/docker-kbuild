FROM alpine:latest
LABEL maintainer "sysadmin@kronostechnologies.com"

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apk update && apk upgrade && apk add --no-cache build-base libpng-dev libtool nasm curl php5-cli php5-json php5-phar php5-openssl php5-zlib nodejs git nodejs-npm sudo bash openssh-client autoconf automake && rm -rf /var/cache/apk/* && find /usr/lib/node_modules -type d -name "test" -exec rm -rf {} \;

RUN ln -s /usr/bin/php5 /usr/bin/php

RUN npm install -g grunt-cli bower \
&& curl -sL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ADD https://raw.githubusercontent.com/kronostechnologies/build/master/kbuild/kbuild /usr/local/bin/kbuild
RUN chmod 755 /usr/local/bin/kbuild

RUN echo "Defaults env_keep += \"SSH_AUTH_SOCK\"" > /etc/sudoers.d/pass_ssh

WORKDIR /code

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
