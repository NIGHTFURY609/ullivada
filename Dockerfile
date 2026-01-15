# --- STAGE 1: BUILD ---
# Use a Maven image to build the app
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the JAR file (Skip tests to speed up deployment)
RUN mvn clean package -DskipTests

# --- STAGE 2: RUN ---
# Use a lightweight Java Runtime (JRE) for the final image
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080 (Standard for Spring Boot)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]