#!/bin/bash

minikube stop && minikube delete && minikube start && kubectl config get-contexts && kubectl config use-context minikube && skaffold run -f=skaffold.yaml && minikube service web --url
# OR
# minikube stop && minikube delete && minikube start && skaffold run && minikube service web --url

