# Stage 1: Build the application using Maven
FROM maven:3.8.7-openjdk-21 AS build

# Set the working directory
WORKDIR /app

# Copy Maven wrapper and settings
COPY mvnw ./
COPY .mvn .mvn/

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN ./mvnw dependency:go-offline -B

# Copy the entire project
COPY . .

# Build the application, skipping tests for speed
RUN ./mvnw clean package -DskipTests

# Stage 2: Run the application
FROM openjdk:21-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/section-03-registration/01-jobportal-registration-project-setup/target/jobportal-0.0.1-SNAPSHOT.jar app.jar

# Expose the port the application runs on
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
