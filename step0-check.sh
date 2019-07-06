#!/bin/bash
# Check if Java is installed and is greater then 1.8

if type -p java; then
    _java=java
else
    echo "[FAILED] No java found | Please install Java 1.8+"
    echo "  Use brew: brew cask install java"
    exit
fi

if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [[ "$version" > "1.8" ]]; then
    	echo "[CHECK!] Found Java version: $version"
    else         
        echo "[FAILED] Java version $version, less than 1.8"
        exit
    fi
fi

# Check if Gradle is installed and is greater then 4
if type -p gradle; then
    _gradle=gradle
else
    echo "[FAILED] No gradle found | Please install Gradle 4+"
    echo "  Use brew: brew install gradle"
    exit
fi

if [[ "$_gradle" ]]; then
    version=$("$_gradle" -version 2>&1 | awk -F '"' '/Gradle/ {print $1}' | cut -d " " -f 2)
    if [[ "$version" > "4" ]]; then
    	echo "[CHECK!] Found Gradle version $version"
    else         
        echo "[FAILED] Gradle version $version, less than 4"
        exit
    fi
fi

# Check if Docker is installed
if type -p docker; then
    _docker=docker
else
    echo "[FAILED] No Docker found | Please install Docker"
    echo "  Use brew: brew cask install docker"
    exit
fi

if [[ "$_docker" ]]; then
    version=$("$_docker" -v 2>&1 | awk -F ' ' '/version/ {print $3}')
    if [[ "$version" > "18" ]]; then
	    echo "[CHECK!] Found Docker version $version"
    else         
        echo "[FAILED] Docker version $version, less than 18"
        exit
    fi
fi
