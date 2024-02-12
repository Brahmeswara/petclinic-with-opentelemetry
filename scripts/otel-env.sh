
export JAVA_TOOL_OPTIONS="-javaagent:PATH/TO/opentelemetry-javaagent.jar" 
export OTEL_JAVAAGENT_EXTENSIONS=opentelemetry-extension-trace-propagators-1.19.0.jar


## Log to console - Enable these environment variables to enable tracing and metrics.
# export OTEL_TRACES_EXPORTER=logging 
# export OTEL_METRICS_EXPORTER=logging 
# expprt OTEL_LOGS_EXPORTER=logging

# zipkin variables
export OTEL_SERVICE_NAME=apigateway-sn
export OTEL_TRACES_EXPORTER=zipkin
export OTEL_METRICS_EXPORTER=zipkin 
export OTEL_LOGS_EXPORTER=zipkin
export OTEL_PROPAGATION_ENABLED=true
export OTEL_PROPAGATION=b3multi
export OTEL_RESOURCE_ATTRIBUTES="service.name=customerservice,service.namespace=demo"
export OTEL_EXPORTER_ZIPKIN_ENDPOINT=http://localhost:9411/api/v2/spans