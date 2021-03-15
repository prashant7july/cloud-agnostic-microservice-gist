# cloud-agnostic-microservice-gist
Sample cloud-agnostic microservice application that can even run on your local system and even any cloud etc

## Details
Robot Shop is a sample microservice application you can use as a sandbox to test and learn containerised application orchestration and monitoring techniques. It is not intended to be a comprehensive reference example of how to write a microservices application, although you will better understand some of those concepts by playing with Robot Shop. To be clear, the error handling is patchy and there is not any security built into the application.

This sample microservice application has been built using these technologies:
- NodeJS ([Express](http://expressjs.com/))
- Java ([Spark Java](http://sparkjava.com/))
- Python ([Flask](http://flask.pocoo.org))
- Golang
- PHP (Apache)
- MongoDB
- Redis
- MySQL
- RabbitMQ
- Nginx
- AngularJS (1.x)

The various services in the sample application already include all required and configured.

## Diagram Link
* [Diagram](https://app.diagrams.net/#G1_EmBlzU-CQhmRvWVPbbzbk6SMK2XqmEP)
![Diagram](https://github.com/prashant7july/micro-gist/blob/main/assets/E-commerce-Solution.png?raw=true)

## Kubernetes
You can run Kubernetes locally using [minikube](https://github.com/kubernetes/minikube) or on one of the many cloud providers.

## Accessing the Store
If you are running the store locally via *docker build and docker run* then, the store front is available on localhost port 8080 [http://localhost:8088](http://localhost:8088/)

If you are running the store on Kubernetes via minikube then, find the IP address of Minikube and the Node Port of the web service.

```shell
$ minikube ip
$ kubectl get svc web
```