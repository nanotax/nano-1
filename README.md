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

# Simple Rest Service built using AWS Code Base [nano-1a]
Will be using the source we have created in "nono-1". The following steps will check for AWS CLI prerequisites, then will add the neccessary Code Build configuration files and finally exececute creation of the Elastic Container Repository and Code Build Project.

Build with:
- AWS CLI

## Step 3: Prerequisites
This step will check for all the neccessary version of the following software:
- Python 3.x
```
brew install python
```
> full installation instruction can be found [here](https://www.saintlad.com/install-python-3-on-mac/)
- aws cli 1.16.x
```
pip3 install awscli
```
> full installation instruction can be found [here](https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html)

Todo an automatic check please run the following script:
```
./step3-check.sh
```
## Step 4: ECR & CodeBuild
This step will setup Elastic Container Repository for your GITHUB project and add Code Build project.
```
./step4-ecr-codebuild.sh <Service Path>
```

## How to use the Greeting Rest Service
Since the Docker image is stored in the AWS Elastic Container Registry, Elastic Container Service can be initiatate with the image. Once launched the following test script can be used: 
```
./testECS <ECS DNS host>
```
### Use case #1: Default Greeting
```
expected='{"id":1,"content":"Hello, World!"}'
actual=$(curl -s "http://<ECS DNS host>:8080/greeting")
```
### Use case #2: Customer Greeting
```
expected2='{"id":2,"content":"Hello, User!"}'
actual2=$(curl -s "http://<ECS DNS host>:8080/greeting?name=User")
```
> Keep in mind if you were to run these test use case more then once, Id field will get incremented and will not longer match with expected value.
