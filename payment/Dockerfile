FROM openjdk:21-slim
WORKDIR /app
COPY target/payment-1.jar app.jar
EXPOSE 8052
ENTRYPOINT ["java","-jar","app.jar"]