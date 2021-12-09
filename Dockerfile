FROM java:openjdk-8-jre-alpine

COPY target/spring-petclinic-*.jar ./spring-petclinic.jar

CMD ["java","-jar","spring-petclinic.jar"]
