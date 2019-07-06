|macOS|
|-----|
# Simple Rest Service [nano-1]

Build with:
- Java
- Gradle
- Spring
- Docker

## Step 0: Prerequisites
This step will check for all the neccessary version of the following software:
- Java 1.8+
- Gradle 4+
- Docker 18+
```
./step0-check.sh
```
## Step 1: Spring App
This step will setup the basic source code for the service, including:
- Greeting Class
- GreetingController Class
- Application Class
- build.gradle
```
./step1-spring-app.sh <NAME>
```
|Run service using JAR|
|:--------------------|
|java -jar build/libs/gs-rest-service-0.1.0.jar|

## Step 2: Docker
This step will setup a basic build script, that will allow to create Docker image. Then it will run it, creating the image. Finally it will launch the Docker image.

```
./step2-docker.sh <NAME>
```
|Build Docker         |
|:--------------------|
|./buildDockerImage.sh|

|Run service using Docker|
|:-----------------------|
|docker run -d --expose 8080 -p 8080:8080 &lt;NAME&gt;|
