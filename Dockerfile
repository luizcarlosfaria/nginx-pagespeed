FROM ubuntu:17.04
MAINTAINER Luiz Carlos Faria
WORKDIR /home

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install wget curl nano build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev libxslt1-dev libxml2-dev zip unzip libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev git -y

# Fix locales
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ENV NGINX_VERSION 1.12.0
ENV NPS_VERSION 1.11.33.4
ENV RTMP_VERSION 1.1.11

RUN pwd && ls -l && echo 1
# Configure

COPY ./setup-02-compile.sh ./setup-02-compile.sh
RUN chmod +x ./setup-02-compile.sh \
&& ls -l \
&& ./setup-02-compile.sh


EXPOSE 80
EXPOSE 443

COPY ./nginx-upstart.conf /etc/init/nginx.conf
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
&& apt-get clean all \
&& mkdir /_config_backup/ \
&& cp /etc/nginx/* /_config_backup/ 

RUN mkdir /var/ngx_pagespeed_cache/ \
&& chmod 777 /var/ngx_pagespeed_cache/

RUN mkdir /var/ngx_pagespeed_log/ \
&& chmod 777 /var/ngx_pagespeed_log/

WORKDIR /

VOLUME ["/etc/nginx/", "/var/log/nginx/"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]