#!/bin/bash

#stop / remove all of Docker containers
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

# Remove one or more networks
docker network rm robot-shop

# create a shared network so the two or more containers can talk to each other
docker network create robot-shop


docker build -t rs-mysql-db:0.0.1 ./ratings-mysql-service

docker run \
  --name=rating-mysql \
  -d \
  --network=robot-shop \
  --env-file=./ratings-mysql-service/env \
  rs-mysql-db:0.0.1

docker build -t rs-ratings:0.0.1 ./ratings-service

docker run \
  --name=ratings \
  -d \
  --network=robot-shop \
  -e RATING_PDO_URL="mysql:host=rating-mysql;port=3306;dbname=ratings;charset=utf8mb4" \
  -e RATING_MYSQL_USER=ratings \
  -e RATING_MYSQL_PASSWORD=secret \
  -p 8086:8080 \
  rs-ratings:0.0.1

# Inspect a shared network
docker network inspect robot-shop

# PHP Info: PHP Version 7.3.14
# curl -X GET http://localhost:8086/info.php
# curl: (56) Recv failure: Connection reset by peer
# Solution
# In docker container run command -p 8086:80 container use different port 80, where as in Dockerfile PORT is 8080
# Delete Docker Container and change docker port -p 8086:8080 in doecker run command

# curl -X PUT http://localhost:8086/api/rate/IUIUY76/687876

# curl -X GET http://localhost:8086/api/fetch/32YTPPP
