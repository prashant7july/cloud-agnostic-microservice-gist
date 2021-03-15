#!/bin/bash
minikube stop
minikube delete
minikube start

eval $(minikube docker-env)
docker build -t rs-catalogue-mongodb:0.0.1 ./catalogue-mongo-service
sleep 5

kubectl create -f ./catalogue-manifest/mongodb-deployment.yaml
kubectl create -f ./catalogue-manifest/mongodb-service.yaml
sleep 5

#eval $(minikube docker-env)
docker build -t rs-catalogue:0.0.1 ./catalogue-service
sleep 5

kubectl create -f ./catalogue-manifest/catalogue-deployment.yaml
kubectl create -f ./catalogue-manifest/catalogue-service.yaml
sleep 5

kubectl get all
kubectl describe pods
kubectl get services
minikube service catalogue --url

# Health Check
# curl -X GET $(minikube service catalogue --url)/health

# products
# curl -X GET $(minikube service catalogue --url)/products

# products/sku
# curl -X GET $(minikube service catalogue --url)/product/K9

# /products/:cat
# curl -X GET $(minikube service catalogue --url)/products/Robot

# /categories
# curl -X GET $(minikube service catalogue --url)/categories

# /search/:text
# curl -X GET $(minikube service catalogue --url)/search/Time