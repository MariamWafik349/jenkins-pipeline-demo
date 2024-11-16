# Stage 1: Build Angular application
FROM node:16 AS frontend
WORKDIR /app
COPY frontend/ /app/
RUN npm install && npm run build

# Stage 2: Build Spring Boot application
FROM maven:3.8.7-openjdk-17 AS backend
WORKDIR /app
COPY backend/ /app/
RUN mvn clean package -DskipTests

# Stage 3: Combine both
FROM openjdk:17
WORKDIR /app
COPY --from=backend /app/target/*.jar app.jar
COPY --from=frontend /app/dist/ /frontend/
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
