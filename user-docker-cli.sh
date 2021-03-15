#!/bin/bash

#stop / remove all of Docker containers
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

# Remove one or more networks
docker network rm robot-shop

# create a shared network so the two or more containers can talk to each other
docker network create robot-shop
docker build -t rs-mongodb:0.0.1 ./user-mongo-service

docker run \
  --name=mongodb \
  -d \
  --network=robot-shop \
  -p 27017:27017 \
  rs-mongodb:0.0.1

# the "alpine" image is very slim (5MB!)
docker run -d -h redis --network=robot-shop -v redis-data:/data -p 6379:6379 --name redis --restart always redis:alpine sh -c 'redis-server --appendonly yes'

docker build -t rs-user:0.0.1 ./user-service
docker run \
  --name=user \
  -d \
  --network=robot-shop \
  -e REDIS_HOST=redis \
  -e REDIS_PORT=6379 \
  -p 8081:8080 \
  rs-user:0.0.1

# Inspect a shared network
docker network inspect robot-shop

# Register API Curl Command -
# curl -X POST http://localhost:8081/register -H 'content-type: application/json' -d '{"name": "Prashant", "email": "prashant7july@gmail.com", "password": "asjdhgad123"}'

# Login API Curl Command -
# curl -X POST http://localhost:8081/login -H 'content-type: application/json' -d '{"name":"Prashant","password":"asjdhgad123"}'

# Health Check
# curl -X GET http://localhost:8081/health

# use REDIS INCR to track anonymous users
# curl -X GET http://localhost:8081/uniqueid

# check user exists
# curl -X GET http://localhost:8081/check/5e40ee89aba043d97c221333

# return all users for debugging only
# curl -X GET http://localhost:8081/users