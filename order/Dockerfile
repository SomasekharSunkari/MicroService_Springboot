FROM openjdk:21-slim
WORKDIR /app
COPY target/order-1.jar app.jar
EXPOSE 8051
ENTRYPOINT ["java","-jar","app.jar"]