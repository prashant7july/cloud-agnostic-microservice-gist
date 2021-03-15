#!/bin/bash

#stop / remove all of Docker containers
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

# Remove one or more networks
docker network rm robot-shop

# create a shared network so the two or more containers can talk to each other
docker network create robot-shop

docker build -t rs-mysql-shipping-db:0.0.1 ./shipping-mysql-service

#docker run --name=mysql -d --network=robot-shop -p 3336:3306 rs-mysql-db:0.0.1
#docker run --name=mysql -d --network=robot-shop --env-file=./shipping-mysql-service/env -p 3336:3306 rs-mysql-shipping-db:0.0.1
docker run \
  --name=mysql \
  -d \
  --network=robot-shop \
  --env-file=./shipping-mysql-service/env \
  -p 3336:3306 \
  rs-mysql-shipping-db:0.0.1

docker build -t rs-shipping:0.0.1 ./shipping-service

#docker run --name=shipping -d --network=robot-shop -e PDO_URL="mysql:host=mysql;port=3307;dbname=shipping;charset=utf8mb4" -e DB_HOST="mysql" -e DB_PORT=3336 -p 8081:8080 rs-shipping:0.0.1
docker run \
  --name=shipping \
  -d \
  --network=robot-shop \
  -e PDO_URL="mysql:host=mysql;port=3307;dbname=shipping;charset=utf8mb4"
  -e DB_HOST="mysql"
  -e DB_PORT=3336
  -p 8081:8080 \
  rs-shipping:0.0.1

# Inspect a shared network
docker network inspect robot-shop

# Check API health
# curl -X GET http://localhost:8081/health

# Total Cities Count API
# curl -X GET http://localhost:8081/count