#!/bin/bash

#stop / remove all of Docker containers
docker stop $(docker ps -a -q) && docker rm -f $(docker ps -a -q)

# Remove all Docker images
docker rmi $(docker images -q)

# Remove all Docker volumes
docker volume rm $(docker volume ls -q -f dangling=true)

# Remove volumes in Docker All
# docker volume rm redis-data
docker volume rm $(docker volume ls -q)

# Used to store and restore database dumps
docker volume create --name rs-redis-data

# Remove one or more networks
docker network rm robot-shop

# create a shared network so the two or more containers can talk to each other
docker network create robot-shop
# OR 
# docker network create -d bridge robot-shop

##########################
#     catalogue Services #
##########################
# catalogue mongoDB
docker build -t rs-catalogue-mongodb:0.0.1 ./catalogue-mongo-service
# Mongodb default port 27017 change as 20000
docker run --name=catalogue-mongodb -d --network=robot-shop rs-catalogue-mongodb:0.0.1 mongod --port 20000

# catalogue service
docker build -t rs-catalogue:0.0.1 ./catalogue-service
docker run --name=catalogue -d --network=robot-shop -e MONGO_URL=mongodb://catalogue-mongodb:20000 rs-catalogue:0.0.1

##########################
#     User Services      #
##########################
# user mongo
docker build -t rs-mongodb:0.0.1 ./user-mongo-service
docker run --name=mongodb -d --network=robot-shop rs-mongodb:0.0.1 mongod --port 20001

# user redis and the "alpine" image is very slim (5MB!) 
docker run -d -h redis --network=robot-shop -v redis-data:/data --name redis --restart always redis:alpine sh -c 'redis-server --appendonly yes'

# user service
docker build -t rs-user:0.0.1 ./user-service
# No need to excess outside the container access in the same network which is robot-shop 
docker run --name=user -d --network=robot-shop -e REDIS_HOST=redis -e REDIS_PORT=6379 -e MONGO_URL='mongodb://mongodb:20001' rs-user:0.0.1

##########################
#     Cart Services      #
##########################
docker build -t rs-cart:0.0.1 ./cart-service
# No need to excess outside the container access in the same network which is robot-shop 
docker run --name=cart -d --network=robot-shop -e REDIS_HOST=redis -e REDIS_PORT=6379 rs-cart:0.0.1

##########################
#   shipping Services    #
##########################
docker build -t rs-mysql-shipping-db:0.0.1 ./shipping-mysql-service
docker run --name=mysql -d --network=robot-shop --env-file=./shipping-mysql-service/env rs-mysql-shipping-db:0.0.1

docker build -t rs-shipping:0.0.1 ./shipping-service
docker run --name=shipping -d --network=robot-shop -e SHIPPING_DB_HOST="mysql" -e SHIPPING_DB_PORT=3306 -e CART_ENDPOINT="cart:8080" rs-shipping:0.0.1

##########################
#    Payment Services    #
##########################
docker run -d --name rabbitmq --restart always --network=robot-shop -p 35672:15672 -p 5682:5672 -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=password rabbitmq:3-management
# curl -u user:password -XGET http://localhost:35672/api/queues

# For Production Use --no-cache
docker build --no-cache -t rs-payment:0.0.1 ./payment-service
docker run --name=payment -d --network=robot-shop -e AMQP_HOST=rabbitmq -e AMQP_PORT=5682 -e AMQP_USER=user -e AMQP_PASSWORD=password rs-payment:0.0.1 

##########################
#    Rating Services     #
##########################
# Issues due to mysql instane also used in shipping services with same mysql default port 3306
docker build -t rs-mysql-db:0.0.1 ./ratings-mysql-service
docker run --name=rating-mysql -d --network=robot-shop --env-file=./ratings-mysql-service/env rs-mysql-db:0.0.1

docker build -t rs-ratings:0.0.1 ./ratings-service
docker run --name=ratings -d --network=robot-shop -e RATING_PDO_URL="mysql:host=rating-mysql;port=3306;dbname=ratings;charset=utf8mb4" -e RATING_MYSQL_USER=ratings -e RATING_MYSQL_PASSWORD=secret rs-ratings:0.0.1

# PHP Info: PHP Version 7.3.14
# curl -X GET http://localhost:8086/info.php
# curl -X PUT http://localhost:8086/api/rate/IUIUY76/687876
# curl -X GET http://localhost:8086/api/fetch/32YTPPP

##########################
#   dispatch Services    #
##########################
# Already Used in Payment
# docker run -d --name rabbitmq --restart always --network=robot-shop -p 35672:15672 -p 5682:5672 -e RABBITMQ_DEFAULT_USER=user -e #RABBITMQ_DEFAULT_PASS=password rabbitmq:3-management
# curl -u user:password -XGET http://localhost:35672/api/queues

# docker build -t rs-dispatch:0.0.1 ./dispatch-service
docker build -f ./dispatch-service/Dockerfile.third -t rs-dispatch:0.0.1 ./dispatch-service
docker run --name=dispatch -d --network=robot-shop -e AMQP_HOST=rabbitmq -e AMQP_PORT=5682 -e AMQP_USER=user -e AMQP_PASSWORD=password rs-dispatch:0.0.1

##########################
#      Web Services      #
##########################

# docker build -t rs-web:0.0.1 ./web-service
# OR
# docker build -f ./web-service/Dockerfile -t rs-web:0.0.1 ./web-service
docker build -f ./web-service/Dockerfile.proxy -t rs-web:0.0.1 ./web-service
# docker build -f ./web-service/Dockerfile.proxy2 -t rs-web:0.0.1 ./web-service
docker run --name=web -d --network=robot-shop -p 8088:80 rs-web:0.0.1

# docker stop web && docker rm web
# apt-get update; apt-get install curl
# and the execute catalogue API
# curl -X GET http://catalogue:8080/health
# curl -X GET http://catalogue:8080/categories

# Inspect a shared network
docker network inspect robot-shop

docker ps

# Front End
curl -X GET http://localhost:$(docker ps|grep web|sed 's/.*0.0.0.0://g'|sed 's/->.*//g')