#!/bin/bash
minikube stop
minikube delete
minikube start

eval $(minikube docker-env)
docker build -t rs-mysql-db:0.0.1 ./ratings-mysql-service
sleep 5

kubectl create -f ./ratings-manifest/mysql-deployment.yaml
kubectl create -f ./ratings-manifest/mysql-service.yaml
sleep 5

eval $(minikube docker-env)
docker build -t rs-ratings:0.0.1 ./ratings-service
sleep 5

kubectl create -f ./ratings-manifest/ratings-deployment.yaml
kubectl create -f ./ratings-manifest/ratings-service.yaml
sleep 5

kubectl get all
kubectl describe pods
kubectl get services
minikube service ratings --url

# PHP Info: PHP Version 7.3.14
# curl -X GET $(minikube service ratings --url)/info.php

# curl -X PUT $(minikube service ratings --url)/api/rate/IUIUY76/687876

# curl -X GET $(minikube service ratings --url)/api/fetch/32YTPPP


