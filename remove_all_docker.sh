docker ps -q | xargs docker stop
docker ps -a | xargs docker rm
