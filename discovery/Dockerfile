FROM openjdk:21-slim
WORKDIR /app
COPY target/discovery-1.jar app.jar
EXPOSE 8761
ENTRYPOINT ["java","-jar","app.jar"]