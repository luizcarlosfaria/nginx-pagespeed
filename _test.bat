docker rm -f customNginx
docker run --name customNginx -d --hostname customNginx -p 80:80 -v %~dp0examples\01-docker.com\nginx.conf:/etc/nginx/nginx.conf -v  %~dp0examples\01-docker.com\logs:/var/log/nginx/ luizcarlosfaria/nginx-pagespeed

