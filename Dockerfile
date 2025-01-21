# Use an official Java runtime as the base image
FROM openjdk:17

# Copy the JAR file into the container
COPY target/jb-hello-world-maven-0.2.0.jar jb-hello-world-maven-0.2.0.jar

# Expose the application port
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "/jb-hello-world-maven-0.2.0.jar"]
