FROM maven:3.9.14-amazoncorretto-17-debian AS builder
LABEL Author="Van Luong"
RUN apt update && apt install git -y
RUN git clone https://github.com/vanluong2003/cicd-webapp.git
RUN cd cicd-webapp && git checkout main && mvn install -DskipTests

FROM tomcat:10.1-jdk17-temurin 
LABEL Author="Van Luong"
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=builder cicd-webapp/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
