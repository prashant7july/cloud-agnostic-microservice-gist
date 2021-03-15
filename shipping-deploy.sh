#!/bin/bash
minikube stop
minikube delete
minikube start

eval $(minikube docker-env)
docker build -t rs-mysql-shipping-db:0.0.1 ./shipping-mysql-service
sleep 5

kubectl create -f ./shipping-manifest/mysql-deployment.yaml
kubectl create -f ./shipping-manifest/mysql-service.yaml
sleep 5

eval $(minikube docker-env)
#mongo.default.svc.cluster.local
#docker run --name=shipping -d -p 8081:8080 rs-shipping:0.0.1
docker build -t rs-shipping:0.0.1 ./shipping-service
sleep 5

kubectl create -f ./shipping-manifest/shipping-deployment.yaml
kubectl create -f ./shipping-manifest/shipping-service.yaml
sleep 5

kubectl get all
kubectl describe pods
kubectl get services
minikube service shipping --url

# Check API health
# curl -X GET $(minikube service shipping --url)/health

# Total Cities Count API
# curl -X GET $(minikube service shipping --url)/count



