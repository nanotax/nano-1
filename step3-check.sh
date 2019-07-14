#!/bin/bash
# Check if Python3 is installed
if type -p python3; then
    _python=python3
    echo "[CHECK!] Found $(python3 --version)"
else
    echo "[FAILED] No python3 found | Please install Python 3.x"
    echo "  Use brew: brew install python"
fi

# Check if aws cli is installed
if type -p aws; then
  	_aws=aws
else
    echo "[FAILED] No aws cli found | Please install aws cli 1.16.x"
    echo "  Use pip3: pip3 install awscli"
fi

if [[ "$_aws" ]]; then
    version=$("$_aws" --version | cut -d "/" -f 2 | cut -d " " -f 1)
    if [[ "$version" > "1.16" ]]; then
    	echo "[CHECK!] Found aws cli version: $version"
    else         
        echo "[FAILED] aws cli version $version, less than 1.16"
        exit
    fi
fi

