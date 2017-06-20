FROM debian:jessie-slim
LABEL maintainer "sysadmin@kronostechnologies.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
 apt-transport-https ca-certificates \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1655A0AB68576280

RUN echo '\
 deb https://deb.debian.org/debian jessie main\n\
 deb https://deb.debian.org/debian-security jessie/updates main\n\
 deb https://deb.nodesource.com/node_6.x jessie main\
' > /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
libpng-dev nodejs php5-cli ruby curl \
build-essential dh-autoreconf nasm git ssh \
sudo \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN gem install -N sass \
&& npm install -g grunt-cli bower \
&& curl -sL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ADD https://raw.githubusercontent.com/kronostechnologies/build/master/kbuild/kbuild /usr/local/bin/kbuild
RUN chmod 755 /usr/local/bin/kbuild

WORKDIR /code

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
