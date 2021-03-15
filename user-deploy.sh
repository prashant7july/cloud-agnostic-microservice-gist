#!/bin/bash
minikube stop
minikube delete
minikube start

eval $(minikube docker-env)
docker build -t rs-mongodb:0.0.1 ./user-mongo-service
sleep 5

kubectl create -f ./user-manifest/mongodb-deployment.yaml
kubectl create -f ./user-manifest/mongodb-service.yaml
sleep 5

kubectl create -f ./user-manifest/redis-deployment.yaml
kubectl create -f ./user-manifest/redis-service.yaml
sleep 5

#eval $(minikube docker-env)
docker build -t rs-user:0.0.1 ./user-service
sleep 5

kubectl create -f ./user-manifest/user-deployment.yaml
kubectl create -f ./user-manifest/user-service.yaml
sleep 5

kubectl get all
kubectl describe pods
kubectl get services
minikube service user --url

# Register API Curl Command -
# curl -X POST $(minikube service user --url)/register -H 'content-type: application/json' -d '{"name": "Prashant", "email": "prashant7july@gmail.com", "password": "asjdhgad123"}'
