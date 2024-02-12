#!/bin/bash

if [ ! -d target ]; then
    echo "Target directory not found"
    exit 1
fi

cd target

java -jar zipkin.jar > zipkin-service.log 2>&1 &
echo "zipkin: $!"

echo "Starting config server"
nohup java -jar ../spring-petclinic-config-server/target/*.jar > config-server.log 2>&1 &
echo "config-server: $!"
echo "Waiting for config server to start"
sleep 20
nohup java -jar ../spring-petclinic-discovery-server/target/*.jar > discovery-server.log 2>&1 &
echo "admin-server: $!"
echo "Waiting for discovery server to start"
sleep 20

# customer service
java -javaagent:opentelemetry-javaagent-1.19.0.jar \
     -Dotel.javaagent.extensions=opentelemetry-extension-trace-propagators-1.19.0.jar \
     -Dotel.propagation.enabled=true \
     -Dotel.propagators=b3multi \
     -Dotel.resource.attributes=service.name=customerservice,service.namespace=demo \
     -Dotel.traces.exporter=zipkin \
     -Dotel.exporter.zipkin.endpoint=http://localhost:9411/api/v2/spans \
     -Dotel.metrics.exporter=none \
     -jar ../spring-petclinic-customers-service/target/*.jar > customers-service.log 2>&1  &

echo "cusomter-service: $?"
# visits service
java -javaagent:opentelemetry-javaagent-1.19.0.jar \
     -Dotel.javaagent.extensions=opentelemetry-extension-trace-propagators-1.19.0.jar \
     -Dotel.propagation.enabled=true \
     -Dotel.propagators=b3multi \
     -Dotel.resource.attributes=service.name=visitsservice,service.namespace=demo \
     -Dotel.traces.exporter=zipkin \
     -Dotel.exporter.zipkin.endpoint=http://localhost:9411/api/v2/spans \
     -Dotel.metrics.exporter=none \
     -jar ../spring-petclinic-visits-service/target/*.jar > visits-service.log 2>&1  &
echo "vists-service: $?"

# vets service
java -javaagent:opentelemetry-javaagent-1.19.0.jar \
     -Dotel.javaagent.extensions=opentelemetry-extension-trace-propagators-1.19.0.jar \
     -Dotel.propagation.enabled=true \
     -Dotel.propagators=b3multi \
     -Dotel.resource.attributes=service.name=vetsservice,service.namespace=demo \
     -Dotel.traces.exporter=zipkin \
     -Dotel.exporter.zipkin.endpoint=http://localhost:9411/api/v2/spans \
     -Dotel.metrics.exporter=none \
     -jar ../spring-petclinic-vets-service/target/*.jar > vets-service.log 2>&1  &
echo "vets-service: $?"

# API Gateway service
java -javaagent:opentelemetry-javaagent-1.19.0.jar \
     -Dotel.javaagent.extensions=opentelemetry-extension-trace-propagators-1.19.0.jar \
     -Dotel.propagation.enabled=true \
     -Dotel.propagators=b3multi \
     -Dotel.resource.attributes=service.name=gatewayservice,service.namespace=demo \
     -Dotel.traces.exporter=zipkin \
     -Dotel.exporter.zipkin.endpoint=http://localhost:9411/api/v2/spans \
     -Dotel.metrics.exporter=none \
     -jar ../spring-petclinic-api-gateway/target/*.jar > api-gateway.log 2>&1  &

echo "gw-service: $?"

nohup java -jar spring-petclinic-admin-server/target/*.jar > admin-server.log 2>&1 &
echo "admin-service: $?"

echo "Waiting for apps to start"
sleep 60

#while ! nc -z localhost 8082; do   
#  sleep 1 
#done

echo "Zipkin url is:    http://localhost:9411/"
