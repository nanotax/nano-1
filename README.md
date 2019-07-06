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
> full installation instruction can be found [here](https://www.code2bits.com/how-to-install-gradle-on-macos-using-homebrew/)
```
brew install gradle
```
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
