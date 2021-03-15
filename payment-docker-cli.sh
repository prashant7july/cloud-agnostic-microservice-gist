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

# For Production Use --no-cache
docker build --no-cache -t rs-payment:0.0.1 ./payment-service
docker run \
  --name=payment \
  -d \
  --network=robot-shop \
  -p 8085:8080 \
  -e AMQP_HOST=rabbitmq \
  -e AMQP_PORT=5682 \
  -e AMQP_USER=user \
  -e AMQP_PASSWORD=password \
  rs-payment:0.0.1

# Inspect a shared network
docker network inspect robot-shop

# Health Check
# curl -X GET http://localhost:8085/health