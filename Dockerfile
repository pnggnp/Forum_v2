# Build stage
FROM maven:3.9-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:11.0-jdk21-eclipse-temurin
WORKDIR /usr/local/tomcat

# Remove default webapps
RUN rm -rf webapps/*

# Copy the WAR file from the build stage to the webapps folder as ROOT.war
COPY --from=build /app/target/*.war webapps/ROOT.war

# Render requires the app to listen on a port provided by the environment variable PORT
# Tomcat default is 8080. We'll use a script to set the port in server.xml if needed,
# but for most Docker deployments on Render, they handle the port mapping.
# If Render expects the app to listen on $PORT, we can configure Tomcat's server.xml.

EXPOSE 8080

CMD ["catalina.sh", "run"]
