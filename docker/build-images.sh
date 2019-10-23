#!/usr/bin/env bash

set -eux

if [ -f Xcode_9.4.1.xip ]; then
    docker build --rm  --build-arg Xcodexip=Xcode_9.4.1.xip -f  cdt-infra-build-macos-sdk/ubuntu-18.04/Dockerfile -t cdt-infra-build-macos-sdk:ubuntu-18.04 .
else
    echo "MacOSX SDK & Toolchain build is being skipped"
fi 

docker build --rm -f cdt-infra-base/ubuntu-18.04/Dockerfile -t cdt-infra-base:ubuntu-18.04 .
docker build --rm -f cdt-infra-all-gdbs/ubuntu-18.04/Dockerfile -t cdt-infra-all-gdbs:ubuntu-18.04 .
docker build --rm -f cdt-infra-eclipse-full/ubuntu-18.04/Dockerfile -t cdt-infra-eclipse-full:ubuntu-18.04 .
docker build --rm -f cdt-infra-platform-sdk/sdk4.9-ubuntu-18.04/Dockerfile -t cdt-infra-platform-sdk:sdk4.9-ubuntu-18.04 .
