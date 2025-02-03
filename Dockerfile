# Use an official Java runtime as the base image
FROM openjdk:17
WORKDIR /app
COPY target/jb-hello-world-maven-0.2.0.jar app.jar
RUN echo "JAR file copied successfully"
CMD ["java", "-jar", "app.jar"]
