#!/bin/bash

minikube stop
minikube delete
minikube start
# minikube --memory 4096 start --mount-string /var/www/html/php/ktest:/mnt/data --mount
# minikube start --mount-string /var/www/html/php/ktest:/mnt/data --mount

echo "Creating the config..."
kubectl apply -f ./config-manifest/ecommerce-configmap.yaml

echo "Creating the redis deployment and service..."
kubectl create -f ./redis-manifest/redis-deployment.yaml
kubectl create -f ./redis-manifest/redis-service.yaml

echo "Creating the rabbitmq deployment and service... use in payment, dispatch"
kubectl create -f ./rabbitmq-manifest/rabbitmq-deployment.yaml
kubectl create -f ./rabbitmq-manifest/rabbitmq-service.yaml
sleep 5

echo "Creating the cart deployment and service..."
eval $(minikube -p minikube docker-env)
#docker build -f ./cart-service/Dockerfile -t rs-cart:0.0.1 ./cart-service
docker build -t rs-cart:0.0.1 ./cart-service
sleep 10
kubectl create -f ./cart-manifest/cart-deployment.yaml
kubectl create -f ./cart-manifest/cart-service.yaml

echo "Creating the mongodb deployment and service..."
#eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
docker build -t rs-catalogue-mongodb:0.0.1 ./catalogue-mongo-service
sleep 5

kubectl create -f ./catalogue-manifest/mongodb-deployment.yaml
kubectl create -f ./catalogue-manifest/mongodb-service.yaml
sleep 5

echo "Creating the catalogue deployment and service..."
#eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
docker build -t rs-catalogue:0.0.1 ./catalogue-service
sleep 5

kubectl create -f ./catalogue-manifest/catalogue-deployment.yaml
kubectl create -f ./catalogue-manifest/catalogue-service.yaml
sleep 5

echo "Creating the dispatch deployment and service..."
#eval $(minikube docker-env)
docker build -f ./dispatch-service/Dockerfile.third -t rs-dispatch:0.0.1 ./dispatch-service
sleep 5

kubectl create -f ./dispatch-manifest/dispatch-deployment.yaml
kubectl create -f ./dispatch-manifest/dispatch-service.yaml
sleep 5

echo "Creating the mongodb deployment and service..."
#eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
docker build -t rs-mongodb:0.0.1 ./user-mongo-service
sleep 5

kubectl create -f ./user-manifest/mongodb-deployment.yaml
kubectl create -f ./user-manifest/mongodb-service.yaml
sleep 5

echo "Creating the user deployment and service..."
#eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
docker build -t rs-user:0.0.1 ./user-service
sleep 5

kubectl create -f ./user-manifest/user-deployment.yaml
kubectl create -f ./user-manifest/user-service.yaml
sleep 5

echo "Creating the Payment deployment and service..."
eval $(minikube -p minikube docker-env)
docker build --no-cache -t rs-payment:0.0.1 ./payment-service
sleep 5

kubectl create -f ./payment-manifest/payment-deployment.yaml
kubectl create -f ./payment-manifest/payment-service.yaml
sleep 5

echo "Creating the Shipping mysql deployment and service..."
#eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
docker build -t rs-mysql-shipping-db:0.0.1 ./shipping-mysql-service
sleep 5

kubectl create -f ./shipping-manifest/mysql-deployment.yaml
kubectl create -f ./shipping-manifest/mysql-service.yaml
sleep 5

echo "Creating the Shipping deployment and service..."
# eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
docker build -t rs-shipping:0.0.1 ./shipping-service
sleep 5

kubectl apply -f ./shipping-manifest/shipping-deployment.yaml
kubectl apply -f ./shipping-manifest/shipping-service.yaml
sleep 5

echo "Creating the Rating deployment and service..."
#eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
docker build -t rs-mysql-db:0.0.1 ./ratings-mysql-service
sleep 5

kubectl apply -f ./ratings-manifest/mysql-deployment.yaml
kubectl apply -f ./ratings-manifest/mysql-service.yaml
sleep 5

#eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
docker build -t rs-ratings:0.0.1 ./ratings-service
sleep 5

kubectl apply -f ./ratings-manifest/ratings-deployment.yaml
kubectl apply -f ./ratings-manifest/ratings-service.yaml
# kubectl exec -it ratings-77f68b9fbb-ss2td -- sh -c "mysql -h rating-mysql -uratings -psecret"

echo "Creating the web deployment and service..."
eval $(minikube -p minikube docker-env)
docker build -f ./web-service/Dockerfile.proxy -t rs-web:0.0.1 ./web-service
# docker build -f ./web-service/Dockerfile.proxy2 -t rs-web:0.0.1 ./web-service
# docker run --name=web -d --network=robot-shop -p 8088:80 rs-web:0.0.1
sleep 5

kubectl apply -f ./web-manifest/web-deployment.yaml
kubectl apply -f ./web-manifest/web-service.yaml
sleep 5

minikube service web --url