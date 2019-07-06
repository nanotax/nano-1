#!/bin/bash
# Check for first argument, the name of first service
if [ -z "$1" ]
  then
    echo "Need to provide a name for first service."
    exit 
fi

mkdir $1
echo "`date '+%Y-%m-%d %H:%M:%S'` | Creating directory: $1"

cd $1

echo "`date '+%Y-%m-%d %H:%M:%S'` | Creating using class: $1"

# Use Build with Gradle section : https://spring.io/guides/gs/rest-service/

# Create a java source directory
mkdir -p src/main/java/$1
echo "`date '+%Y-%m-%d %H:%M:%S'` | Created java source directory"

# Add Gradle Build file
echo "buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath('org.springframework.boot:spring-boot-gradle-plugin:2.1.6.RELEASE')
    }
}

apply plugin: 'java'
apply plugin: 'eclipse'
apply plugin: 'idea'
apply plugin: 'org.springframework.boot'
apply plugin: 'io.spring.dependency-management'

bootJar {
    baseName = 'gs-rest-service'
    version =  '0.1.0'
}

repositories {
    mavenCentral()
}

sourceCompatibility = 1.8
targetCompatibility = 1.8

dependencies {
    compile('org.springframework.boot:spring-boot-starter-web')
    testCompile('org.springframework.boot:spring-boot-starter-test')
}" > build.gradle
echo "`date '+%Y-%m-%d %H:%M:%S'` | Added Gradle build script"

# Add Greeting Class
echo "package $1;

public class Greeting {

    private final long id;
    private final String content;

    public Greeting(long id, String content) {
        this.id = id;
        this.content = content;
    }

    public long getId() {
        return id;
    }

    public String getContent() {
        return content;
    }
}" > src/main/java/$1/Greeting.java

echo "`date '+%Y-%m-%d %H:%M:%S'` | Added Greeting java class"


# Add Greeting Controller Class
echo "package $1;

import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

    private static final String template = \"Hello, %s!\";
    private final AtomicLong counter = new AtomicLong();

    @RequestMapping(\"/greeting\")
    public Greeting greeting(@RequestParam(value=\"name\", defaultValue=\"World\") String name) {
        return new Greeting(counter.incrementAndGet(),
                            String.format(template, name));
    }
}" > src/main/java/$1/GreetingController.java

echo "`date '+%Y-%m-%d %H:%M:%S'` | Added GreetingContrller java class"

# Add Main Application Class
echo "package $1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}" > src/main/java/$1/Application.java

echo "`date '+%Y-%m-%d %H:%M:%S'` | Added Application java class"

# Compile and Build
gradle build
echo "`date '+%Y-%m-%d %H:%M:%S'` | Built JAR for $1"

# Start service using built JAR file
echo "`date '+%Y-%m-%d %H:%M:%S'` | Starting service $1"
java -jar build/libs/gs-rest-service-0.1.0.jar &
pid=$!

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
echo "`date '+%Y-%m-%d %H:%M:%S'` | Shutting down pid: $pid"
kill -9 $pid

echo "`date '+%Y-%m-%d %H:%M:%S'` | Done"
