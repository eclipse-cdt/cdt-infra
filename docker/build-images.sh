#!/usr/bin/env bash

set -eux

# Xcode_9.4.1.xip is needed to build the OSx cross compiler image from https://download.developer.apple.com/Developer_Tools/Xcode_9.4.1/Xcode_9.4.1.xip
# As an optimization for the rebuild times, the image is only built if the xip is present.
if [ -f Xcode_9.4.1.xip ]; then
    docker build --rm  --build-arg Xcodexip=Xcode_9.4.1.xip -f  cdt-infra-build-macos-sdk/ubuntu-18.04/Dockerfile -t cdt-infra-build-macos-sdk:ubuntu-18.04 .
else
    echo "MacOSX SDK & Toolchain build is being skipped"
fi 

docker build --rm -f cdt-infra-base/ubuntu-18.04/Dockerfile -t cdt-infra-base:ubuntu-18.04 .
docker build --rm -f cdt-infra-all-gdbs/ubuntu-18.04/Dockerfile -t cdt-infra-all-gdbs:ubuntu-18.04 .
docker build --rm -f cdt-infra-eclipse-full/ubuntu-18.04/Dockerfile -t cdt-infra-eclipse-full:ubuntu-18.04 .
docker build --rm -f cdt-infra-platform-sdk/sdk4.13-ubuntu-18.04/Dockerfile -t cdt-infra-platform-sdk:sdk4.13-ubuntu-18.04 .
