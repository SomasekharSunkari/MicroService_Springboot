FROM openjdk:21-slim
WORKDIR /app
COPY target/gateway-1.jar app.jar
EXPOSE 8222
ENTRYPOINT ["java","-jar","app.jar"]  