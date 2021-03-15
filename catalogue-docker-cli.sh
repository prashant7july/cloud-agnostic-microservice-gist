#!/bin/bash

#stop / remove all of Docker containers
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

# Remove one or more networks
docker network rm robot-shop

# create a shared network so the two or more containers can talk to each other
docker network create robot-shop

docker build -t rs-catalogue-mongodb:0.0.1 ./catalogue-mongo-service
docker run \
  --name=catalogue-mongodb \
  -d \
  --network=robot-shop \
  -p 27017:27017 \
  rs-catalogue-mongodb:0.0.1

docker build -t rs-catalogue:0.0.1 ./catalogue-service
docker run \
  --name=catalogue \
  -d \
  --network=robot-shop \
  -p 8082:8080 \
  rs-catalogue:0.0.1

# Inspect a shared network
docker network inspect robot-shop

# Health Check
# curl -X GET http://localhost:8082/health

# /products
# curl -X GET http://localhost:8082/products

# /products/:sku
# curl -X GET http://localhost:8082/product/K9

# /products/:cat
# curl -X GET http://localhost:8082/products/Robot

# /categories
# curl -X GET http://localhost:8081/categories

# /search/:text
# curl -X GET http://localhost:8081/search/Time