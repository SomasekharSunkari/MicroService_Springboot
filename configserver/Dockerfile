FROM openjdk:21-slim
WORKDIR /app
COPY target/configserver-1.jar app.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","app.jar"]