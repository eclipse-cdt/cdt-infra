#!/usr/bin/env bash

namespace=$1

if [ -z "$namespace" ]
then
    echo "Must supply namespace for deploy"
    exit -1
fi

docker tag cdt-infra-eclipse-full:ubuntu-16.04 $namespace/cdt-infra-eclipse-full:ubuntu-16.04
docker push $namespace/cdt-infra-eclipse-full:ubuntu-16.04
docker tag cdt-infra-platform-sdk:sdk4.9-ubuntu-16.04 $namespace/cdt-infra-platform-sdk:sdk4.9-ubuntu-16.04
docker push $namespace/cdt-infra-platform-sdk:sdk4.9-ubuntu-16.04