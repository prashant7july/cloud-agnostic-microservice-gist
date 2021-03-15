#!/bin/bash

#stop / remove all of Docker containers
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

# Remove one or more networks
docker network rm robot-shop

# create a shared network so the two or more containers can talk to each other
docker network create robot-shop

# the "alpine" image is very slim (5MB!)
docker run -d -h redis --network=robot-shop -v redis-data:/data -p 6379:6379 --name redis --restart always redis:alpine sh -c 'redis-server --appendonly yes'

docker build -t rs-cart:0.0.1 ./cart-service
docker run \
  --name=cart \
  -d \
  --network=robot-shop \
  -e REDIS_HOST=redis \
  -e REDIS_PORT=6379 \
  -p 8081:8080 \
  rs-cart:0.0.1

# Inspect a shared network
docker network inspect robot-shop

# metrics check in Prometheus
# curl -X GET http://localhost:8081/metrics