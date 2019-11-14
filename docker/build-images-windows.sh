#!/usr/bin/env bash

set -eu

docker build --rm -f cdt-infra-windows-toolchain/servercore-1809/Dockerfile -t cdt-infra-windows-toolchain:servercore-1809 .
docker build --rm -f cdt-infra-windows/servercore-1809/Dockerfile -t cdt-infra-windows:servercore-1809 .
