#remove all non-running container
docker rm -f $(docker ps -a -q)

#remove all untagged images
docker rmi -f $(docker images | grep "^<none>" | awk '{print $3}')
docker rmi  achyutdev/docker-asterisk

#build Docker image
docker build -rm -t achyutdev/docker-asterisk