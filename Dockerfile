FROM openjdk:26-ea-25-jdk-bookworm
ADD jarstaging/com/valaxy/demo-workshop/2.1.3/demo-workshop-2.1.3.jar ttrend.jar
ENTRYPOINT ["java","-jar","ttrend.jar"]