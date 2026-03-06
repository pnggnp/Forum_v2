# Build stage
FROM maven:3.9-eclipse-temurin-25-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:11.0-jdk25-temurin-noble
WORKDIR /usr/local/tomcat

# Remove default webapps
RUN rm -rf webapps/*

# Copy the WAR file from the build stage to the webapps folder as ROOT.war
COPY --from=build /app/target/*.war webapps/ROOT.war

# Render requires the app to listen on the port provided by the $PORT env variable.
# We use a shell command to dynamically replace port 8080 in server.xml at startup.
EXPOSE 8080

CMD ["sh", "-c", "sed -i \"s/8080/${PORT:-8080}/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]
