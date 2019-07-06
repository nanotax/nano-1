#!/bin/bash
# Check for first argument, the name of first service
if [ -z "$1" ]
  then
    echo "Need to provide a name for first service."
    exit 
fi

cd $1

# Create Docker file
echo "FROM java:8-jre-alpine

ARG VERSION
COPY build/libs/gs-rest-service-0.1.0.jar /opt/$1/$1.jar
ENTRYPOINT java -jar /opt/$1/$1.jar" > Dockerfile

echo "`date '+%Y-%m-%d %H:%M:%S'` | Added Dockerfile"

# Add build Docker Image shell script
echo "#!/bin/bash
docker build -t $1 ." > buildDockerImage.sh
chmod +x buildDockerImage.sh

echo "`date '+%Y-%m-%d %H:%M:%S'` | Added Build Docker Image shell"

# Build docker image
echo "`date '+%Y-%m-%d %H:%M:%S'` | Start Docker Image build ..."
./buildDockerImage.sh
echo "`date '+%Y-%m-%d %H:%M:%S'` | Done"

# Start docker image
echo "`date '+%Y-%m-%d %H:%M:%S'` | Lunching Docker Image ..."

# Starting container and exposing internal port 8080 (with --expose) and external port 8080 (with -p)
docker run -d --expose 8080 -p 8080:8080 $1

# Remember container ID
containerId=`docker ps -l -q`

# Wait for the srvice to start
sleep 25
echo "`date '+%Y-%m-%d %H:%M:%S'` | Done"

# Load first test page, expecting JSON Output: {"id":1,"content":"Hello, World!"}
expected1='{"id":1,"content":"Hello, World!"}'
actual1=$(curl -s "http://localhost:8080/greeting")
if [[ $actual1 = $expected1 ]]
then
    echo "`date '+%Y-%m-%d %H:%M:%S'` | Passed Test 1"
else
    echo "`date '+%Y-%m-%d %H:%M:%S'` | Failed Test 1, expected: $expected1, actual: $actual1"
fi

# Wait for 15 seconds
sleep 15

# Load second test page, expecting JSON Output: {"id":2,"content":"Hello, User!"}
expected2='{"id":2,"content":"Hello, User!"}'
actual2=$(curl -s "http://localhost:8080/greeting?name=User")
if [[ $actual2 = $expected2 ]]
then
    echo "`date '+%Y-%m-%d %H:%M:%S'` | Passed Test 2"
else
    echo "`date '+%Y-%m-%d %H:%M:%S'` | Failed Test 2, expected: $expected2, actual: $actual2"
fi

# Continue running service for next 60 seconds
sleep 60

# Shut down the service
echo "`date '+%Y-%m-%d %H:%M:%S'` | Shutting down container: $containerId"

# Stop and forcefully remove the container
docker rm -f $containerId

echo "`date '+%Y-%m-%d %H:%M:%S'` | Done"
