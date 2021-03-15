#!/bin/bash

#stop / remove all of Docker containers
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

# Remove one or more networks
docker network rm robot-shop

# create a shared network so the two or more containers can talk to each other
docker network create robot-shop

# rabbitMQ
docker run -d --name rabbitmq --restart always --network=robot-shop -p 35672:15672 -p 5682:5672 -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=password rabbitmq:3-management
# curl -u user:password -XGET http://localhost:35672/api/queues

#docker build -t rs-dispatch:0.0.1 ./dispatch-service
docker build -f ./dispatch-service/Dockerfile.third -t rs-dispatch:0.0.1 ./dispatch-service

docker run \
  --name=dispatch \
  -d \
  --network=robot-shop \
  -p 8083:80 \
  -e AMQP_HOST=rabbitmq \
  -e AMQP_PORT=5682 \
  -e AMQP_USER=user \
  -e AMQP_PASSWORD=password \
  rs-dispatch:0.0.1

# Inspect a shared network
docker network inspect robot-shop

curl -X GET http://localhost:8083/health