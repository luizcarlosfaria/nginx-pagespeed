#!/bin/bash
set -e

sudo mkdir /home/build
cd /home/build/
echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################'
# Download ngx_http_substitutions_filter_module
    sudo git clone git://github.com/yaoweibin/ngx_http_substitutions_filter_module.git
    echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################'
#Dowload do nginx-rtmp-module
    wget "https://github.com/arut/nginx-rtmp-module/archive/v${RTMP_VERSION}.tar.gz" \
    && tar -xzvf v${RTMP_VERSION}.tar.gz  # extracts RTM/ 
    echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################'
# Download Google Page Speed
    echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################'
    wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -O release-${NPS_VERSION}-beta.zip
    unzip release-${NPS_VERSION}-beta.zip
    cd /home/build/ngx_pagespeed-release-${NPS_VERSION}-beta/
    echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################'
    wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz \
    && tar -xzvf ${NPS_VERSION}.tar.gz  # extracts to psol/ 
    echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################'


# Download Nginx
cd /home/build/
sudo wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
sudo tar -zxvf nginx-${NGINX_VERSION}.tar.gz 
cd /home/build/nginx-${NGINX_VERSION}
echo '###############################################################################################' && pwd && ls -l && echo '###############################################################################################'

sudo ./configure \
    --prefix=/usr/local/nginx \
    --sbin-path=/usr/local/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/lock/subsys/nginx \
    --user=nginx \
    --group=nginx \
    --with-file-aio \
    --with-ipv6 \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_xslt_module \
    --with-stream \
    --with-http_image_filter_module \
    --with-http_geoip_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_degradation_module \
    --with-http_stub_status_module \
    --with-http_perl_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-pcre \
    --with-google_perftools_module \
    --add-module=../ngx_http_substitutions_filter_module \
    --add-module=../ngx_pagespeed-release-${NPS_VERSION}-beta \
    --add-module=../nginx-rtmp-module-${RTMP_VERSION} 
    
                                    # --with-debug
                                    #Configuration summary
                                    #  + using system PCRE library
                                    #  + using system OpenSSL library
                                    #  + md5: using OpenSSL library
                                    #  + sha1: using OpenSSL library
                                    #  + using system zlib library

                                    #  nginx path prefix: "/usr/local/nginx"
                                    #  nginx binary file: "/usr/local/sbin/nginx"
                                    #  nginx configuration prefix: "/etc/nginx"
                                    #  nginx configuration file: "/etc/nginx/nginx.conf"
                                    #  nginx pid file: "/run/nginx.pid"
                                    #  nginx error log file: "/var/log/nginx/error.log"
                                    #  nginx http access log file: "/var/log/nginx/access.log"
                                    #  nginx http client request body temporary files: "client_body_temp"
                                    #  nginx http proxy temporary files: "proxy_temp"
                                    #  nginx http fastcgi temporary files: "fastcgi_temp"
                                    #  nginx http uwsgi temporary files: "uwsgi_temp"
                                    #  nginx http scgi temporary files: "scgi_temp"
                                    


sudo make
sudo make install
sudo useradd -r nginx


sudo apt-get clean \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /home/build/*

