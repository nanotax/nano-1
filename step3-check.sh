#!/bin/bash
# Check if Python3 is installed
if type -p python3; then
  	echo "[CHECK!] Found Python 3"
else
    echo "[FAILED] Python 3 is not installed"
    echo "  Use brew: brew install python"
fi

# Check if aws cli is installed
if type -p aws; then
  	echo "[CHECK!] Found aws cli"
else
    echo "[FAILED] aws cli is not installed"
    echo "  Use pip3: pip3 install awscli"
fi