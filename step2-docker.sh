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

# Add start Docker shell script
echo "#!/bin/bash
# Starting container and exposing internal port 8080 (with --expose) and external port 8080 (with -p)
docker run -d --name $1 --expose 8080 -p 8080:8080 $1

# Wait for the srvice to start
sleep 25" > start.sh
chmod +x start.sh

# Add stop Docker shell script
echo "#!/bin/bash
# Stop and forcefully remove the container
docker rm -f \`docker ps -aqf \"name=$1\"\`" > stop.sh
chmod +x stop.sh

# Start docker image
echo "`date '+%Y-%m-%d %H:%M:%S'` | Launching Docker container"
./start.sh
echo "`date '+%Y-%m-%d %H:%M:%S'` | Done"

# Run Tests
echo "`date '+%Y-%m-%d %H:%M:%S'` | Start Tests"
../test.sh 
echo "`date '+%Y-%m-%d %H:%M:%S'` | Done"

# Shut down the service
echo "`date '+%Y-%m-%d %H:%M:%S'` | Shutting down Docker container"
./stop.sh
echo "`date '+%Y-%m-%d %H:%M:%S'` | Done"