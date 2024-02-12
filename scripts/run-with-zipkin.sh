#!/bin/bash

if [ ! -d target ]; then
    echo "Target directory not found"
    exit 1
fi

cd target

java -jar zipkin.jar > zipkin-service.log 2>&1 &
zipkin_pid=$!
echo "zipkin: $!"

echo "Starting config server"
nohup java -jar ../spring-petclinic-config-server/target/*.jar > config-server.log 2>&1 &
config_server_pid=$!
echo "config-server: $!"
echo "Waiting for config server to start"
sleep 20
nohup java -jar ../spring-petclinic-discovery-server/target/*.jar > discovery-server.log 2>&1 &
discovery_server_pid=$!
echo "dis-server: $!"
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

customer_service_pid=$!
echo "cusomter-service: $!"
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

visits_service_pid=$!
echo "vists-service: $!"

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

vets_service_pid=$!
echo "vets-service: $!"

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

gw_service_pid=$!
echo "gw-service: $!"

nohup java -jar spring-petclinic-admin-server/target/*.jar > admin-server.log 2>&1 &

admin_service_pid=$!
echo "admin-service: $!"

echo "Waiting for apps to start"
sleep 60

#while ! nc -z localhost 8082; do   
#  sleep 1 
#done

echo "Zipkin url is:    http://localhost:9411/"

echo "command to stop the services: kill -9 $zipkin_pid $config_server_pid $discovery_server_pid $customer_service_pid $visits_service_pid $vets_service_pid $gw_service_pid $admin_service_pid"
