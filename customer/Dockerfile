FROM openjdk:21-slim
WORKDIR /app
COPY target/customer-1.jar app.jar
EXPOSE 8053
ENTRYPOINT ["java","-jar","app.jar"]