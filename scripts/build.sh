#!/bin/bash

mvn clean package 

mkdir -p target

if [ ! -d target ]; then
    echo "target directory not found"
    exit 1
fi

echo "------------------------------------------"
echo "    Changing to current directory to target folder  "
echo "------------------------------------------"
cd target
pwd


echo "--------------------------------"
echo "    Download Zipkin"
echo "--------------------------------"

if [ -f "zipkin.jar" ]; then
    echo "zipkin.jar already downloaded"
else
    curl -sSL https://zipkin.io/quickstart.sh | bash -s
fi

echo "--------------------------------"
echo "    Build PetClinic App"
echo "--------------------------------"
#mvn clean package -DskipTests


echo "--------------------------------"
echo "    Download OpenTelemetry"
echo "--------------------------------"

if [ -f "opentelemetry-javaagent-1.19.0.jar" ]; then
    echo "opentelemetry-javaagent-1.19.0.jar already downloaded"
else
    curl -o opentelemetry-javaagent-1.19.0.jar https://repo1.maven.org/maven2/io/opentelemetry/javaagent/opentelemetry-javaagent/1.19.0/opentelemetry-javaagent-1.19.0.jar
fi

if [ -f "opentelemetry-extension-trace-propagators-1.19.0.jar" ]; then
    echo "opentelemetry-extension-trace-propagators-1.19.0.jar already downloaded"
else
    curl -o opentelemetry-extension-trace-propagators-1.19.0.jar https://repo1.maven.org/maven2/io/opentelemetry/opentelemetry-extension-trace-propagators/1.19.0/opentelemetry-extension-trace-propagators-1.19.0.jar
fi

cd ..
