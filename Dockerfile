FROM ubuntu:14.04
MAINTAINER Luiz Carlos Faria
WORKDIR /home

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Fix locales
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

RUN sudo apt-get update && \
sudo apt-get install wget curl nano build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev libxslt1-dev libxml2-dev zip unzip libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev git -y

ENV NGINX_VERSION 1.11.4
ENV NPS_VERSION 1.11.33.3
ENV RTMP_VERSION 1.1.9

RUN pwd && ls -l
# Configure
COPY ./setup-02-compile.sh setup-02-compile.sh
RUN chmod +x ./setup-02-compile.sh \
&& echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################' \
&& ./setup-02-compile.sh \
&& echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################'

EXPOSE 80
EXPOSE 443

COPY ./nginx-upstart.conf /etc/init/nginx.conf
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
&& apt-get clean all \
&& mkdir /_config_backup/ \
&& cp /etc/nginx/* /_config_backup/ 

WORKDIR /

VOLUME ["/etc/nginx/", "/var/log/nginx/"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]