# ---- Stage 1: build the WAR with Maven ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN cp src/main/resources/application-dev.properties.template src/main/resources/application-dev.properties
RUN mvn clean package -DskipTests -B

# ---- Stage 2: run on Tomcat 10.1 (required for Jakarta Servlet 6.0) ----
FROM tomcat:10.1-jdk21-temurin
ENV CATALINA_OPTS="--enable-preview"
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/target/LaceBank.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]