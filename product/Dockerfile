# ---------- STAGE 1: Build ----------
FROM public.ecr.aws/docker/library/maven:3.9.8-eclipse-temurin-21 AS builder
WORKDIR /app
   
# Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src 
RUN mvn clean package -DskipTests

# ---------- STAGE 2: Run ----------
FROM public.ecr.aws/docker/library/eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy only the built jar from builder
COPY --from=builder /app/target/product-*.jar app.jar

EXPOSE 8050
ENTRYPOINT ["java","-jar","app.jar"]
