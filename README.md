|macOS|
|-----|
# Simple Rest Service [nano-1]
This Rest Web Service documentated provided by Spring - [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/). The rest of the scripts will create initial java source. Build it with Gradle using Spring Boot, and finally package into a Docker container.

Build with:
- Java
- Gradle
- Spring
- Docker

## Step 0: Prerequisites
This step will check for all the neccessary version of the following software:
- Java 1.8+ 
```
brew tap caskroom/cask
brew cask install caskroom/versions/java8
```
> full installation instruction can be found [here](https://www.chrisjmendez.com/2018/10/14/how-to-install-java-on-osx-using-homebrew/)
- Gradle 4+
```
brew install gradle
```
> full installation instruction can be found [here](https://www.code2bits.com/how-to-install-gradle-on-macos-using-homebrew/)
- Docker 18+ 
```
brew tap caskroom/cask
brew cask install docker
```
> full installation instruction can be found [here](https://www.code2bits.com/how-to-install-docker-on-macos-using-homebrew/)

Todo an automatic check please run the following script:
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

## How to use the Greeting Rest Service
Assuming the service is running on "localhost" with "hello" as its name, lets test the follwoing use cases:
### Use case #1: Default Greeting
```
expected='{"id":1,"content":"Hello, World!"}'
actual=$(curl -s "http://localhost:8080/greeting")
```
### Use case #2: Customer Greeting
```
expected2='{"id":2,"content":"Hello, User!"}'
actual2=$(curl -s "http://localhost:8080/greeting?name=User")
```
> Keep in mind if you were to run these test use case more then once, Id field will get incremented and will not longer match with expected value.
