docker run --name EntryPoint -d --hostname EntryPoint -p 80:80 -v c:/docker/EntryPoint/config:/etc/nginx/ -v  c:/docker/EntryPoint/logs:/var/log/nginx/ luizcarlosfaria/nginx-pagespeed
docker ps -a --filter "name=EntryPoint"
timeout 1
docker ps -a --filter "name=EntryPoint"
timeout 1
docker ps -a --filter "name=EntryPoint"
docker logs EntryPoint
docker rm EntryPoint

