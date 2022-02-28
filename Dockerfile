FROM openjdk:11-jre-slim

RUN mkdir -p /application

COPY ./target/Hello-Application-0.0.1-SNAPSHOT.jar /application/app.jar

WORKDIR /application

ENTRYPOINT [ "java", "-jar", "/application/app.jar" ]

EXPOSE 8080
