#
# Build
#
FROM openjdk:8-jdk AS build
RUN apt-get update && apt-get -y install maven
WORKDIR /opt/shipping
COPY pom.xml /opt/shipping/
RUN mvn install
COPY src /opt/shipping/src/
RUN mvn package

#
# Run
#
FROM openjdk:8-jdk
EXPOSE 8080
WORKDIR /opt/shipping
ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql
#ENV DB_PORT=3306
COPY --from=build /opt/shipping/target/shipping-1.0-jar-with-dependencies.jar shipping.jar
CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]

#OR
#FROM maven:3.6.1-jdk-8-slim AS build
#RUN mkdir -p /workspace
#WORKDIR /workspace
#COPY pom.xml /workspace
#COPY src /workspace/src
#RUN mvn -f pom.xml clean package

#FROM openjdk:8-alpine
#COPY --from=build /workspace/target/*.jar app.jar
#EXPOSE 8080
#ENTRYPOINT ["java","-jar","app.jar"]