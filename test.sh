#!/bin/bash

# Load first test page, expecting JSON Output: {"id":1,"content":"Hello, World!"}
expected1='{"id":1,"content":"Hello, World!"}'
actual1=$(curl -s "http://localhost:8080/greeting")
if [[ $actual1 = $expected1 ]]
then
    echo "`date '+%Y-%m-%d %H:%M:%S'` | Passed Test 1"
else
    echo "`date '+%Y-%m-%d %H:%M:%S'` | Failed Test 1, expected: $expected1, actual: $actual1"
fi

# Load second test page, expecting JSON Output: {"id":2,"content":"Hello, User!"}
expected2='{"id":2,"content":"Hello, User!"}'
actual2=$(curl -s "http://localhost:8080/greeting?name=User")
if [[ $actual2 = $expected2 ]]
then
    echo "`date '+%Y-%m-%d %H:%M:%S'` | Passed Test 2"
else
    echo "`date '+%Y-%m-%d %H:%M:%S'` | Failed Test 2, expected: $expected2, actual: $actual2"
fi
