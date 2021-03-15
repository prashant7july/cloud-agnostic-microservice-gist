#!/bin/bash
minikube stop
minikube delete
minikube start

#eval $(minikube docker-env)
kubectl create -f ./cart-manifest/redis-deployment.yaml
kubectl create -f ./cart-manifest/redis-service.yaml
sleep 5

eval $(minikube docker-env)
docker build -t rs-cart:0.0.1 ./cart-service
sleep 5

kubectl apply -f ./cart-manifest/ecommerce-configmap.yaml

kubectl create -f ./cart-manifest/cart-deployment.yaml
kubectl create -f ./cart-manifest/cart-service.yaml
sleep 5

kubectl get all
kubectl describe pods
kubectl get services
minikube service cart --url

# Prometheus
# curl -X GET $(minikube service cart --url)/metrics
