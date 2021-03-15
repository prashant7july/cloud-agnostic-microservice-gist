#!/bin/bash
minikube stop
minikube delete
minikube start

kubectl create -f ./dispatch-manifest/rabbitmq-deployment.yaml
kubectl create -f ./dispatch-manifest/rabbitmq-service.yaml
sleep 5

eval $(minikube docker-env)
docker build -f ./dispatch-service/Dockerfile.third -t rs-dispatch:0.0.1 ./dispatch-service
sleep 5

kubectl create -f ./dispatch-manifest/dispatch-deployment.yaml
kubectl create -f ./dispatch-manifest/dispatch-service.yaml
sleep 5

kubectl get all
kubectl describe pods
kubectl get services
minikube service dispatch --url