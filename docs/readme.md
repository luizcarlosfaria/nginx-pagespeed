# Supported tags and respective ```Dockerfile``` links

* [```nginx-1.10.1--pagespeed-1.11.33.3```](https://github.com/docker-gallery/nginx-pagespeed/blob/master/Dockerfile), [```latest```](https://github.com/docker-gallery/nginx-pagespeed/blob/master/Dockerfile) [(Dockerfile)](https://github.com/docker-gallery/nginx-pagespeed/blob/master/Dockerfile)

## Include
This image contains Nginx built with modules:
* Nginx 1.10.1
* ngx_http_substitutions_filter_module
* Google Page Speed  1.11.33.3

## How to use this image

```
docker run --name customNginx -d --hostname customNginx -p 80:80 -v /some/config:/etc/nginx/ -v  /some/logs:/var/log/nginx/ luizcarlosfaria/nginx-pagespeed
```

## Volumes
* "/etc/nginx/" - Configuration files
* "/var/log/nginx/" - Logs

Nginx build variables and paths:
```
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
```

## Based on [ubuntu:14.04](https://hub.docker.com/_/ubuntu/) image
This image is based on Ubuntu:14.04 official image.

## Full featured NGINX configuration using Google Page Speed
This can be placed on ```/some/config/nginx.conf``` on host or ```/etc/nginx/nginx.conf``` on container.
```
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;
	pagespeed GlobalStatisticsPath /ngx_pagespeed_global_statistics;
	pagespeed GlobalAdminPath /pagespeed_global_admin;

    server {
        listen       80;
        server_name  localhost;
		####################################################################################################
		pagespeed on;
		# Needs to exist and be writable by nginx.  Use tmpfs for best performance.
		pagespeed FileCachePath /var/ngx_pagespeed_cache/;
		pagespeed MessagesPath /ngx_pagespeed_message;
		pagespeed ConsolePath /pagespeed_console;
		pagespeed AdminPath /pagespeed_admin;
		
		pagespeed StatisticsPath /pagespeed_statistics;

		# Ensure requests for pagespeed optimized resources go to the pagespeed handler
		# and no extraneous headers get set.
		location ~ "\.pagespeed\.([a-z]\.)?[a-z]{2}\.[^.]{10}\.[^.]+" {
		add_header "" "";
		}
		location ~ "^/pagespeed_static/" { }
		location ~ "^/ngx_pagespeed_beacon$" { }		
		
		####################################################################################################
		#location /ngx_pagespeed_statistics 			{ allow all; }
		#location /ngx_pagespeed_global_statistics 	{ allow all; }
		#location /ngx_pagespeed_message 			{ allow all; }
		#location /pagespeed_console 				{ allow all; }
		#location ~ ^/pagespeed_admin 				{ allow all; }
		#location ~ ^/pagespeed_global_admin 		{ allow all; }
		####################################################################################################

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

		 location /v2/ {

			pagespeed EnableFilters move_css_to_head;
			pagespeed EnableFilters combine_javascript;
			pagespeed MaxCombinedJsBytes 999999999;
			pagespeed CombineAcrossPaths on;
			pagespeed MaxSegmentLength 2048;
			pagespeed EnableFilters responsive_images,resize_images;
			pagespeed EnableFilters responsive_images_zoom;
			pagespeed EnableFilters collapse_whitespace;
            
			proxy_pass      http://my-remove-app-to-test:80/v2/;
                        proxy_set_header X-Real-IP $remote_addr;
		}

        
    }

   

}

```
