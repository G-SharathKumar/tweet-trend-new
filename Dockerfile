FROM openjdk:18
ADD jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrend.jar
ENTRYPOINt ['java','-jar','ttrend.jar']