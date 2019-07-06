# Simple Rest Service [nano-1]

Build with:
- Java
- Gradle
- Spring
- Docker

## Step 0: Prerequisites
```
./step0-check.sh
```
## Step 1: Spring App
```
./step1-spring-app.sh <NAME>
```
|Run service using JAR|
|:--------------------|
|java -jar build/libs/gs-rest-service-0.1.0.jar|

## Step 2: Docker
```
./step2-docker.sh <NAME>
```
|Build Docker         |
|:--------------------|
|./buildDockerImage.sh|

|Run service using Docker|
|:-----------------------|
|docker run -d --expose 8080 -p 8080:8080 &lt;NAME&gt;|
