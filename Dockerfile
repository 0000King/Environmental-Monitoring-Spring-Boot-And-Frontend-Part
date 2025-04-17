# Use official Tomcat base image with JSP support
FROM tomcat:9.0-jdk11

# Clean default webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR into the ROOT context of Tomcat
COPY target/EnvironmentalMonitoring-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]