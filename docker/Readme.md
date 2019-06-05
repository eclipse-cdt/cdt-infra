Dockerfiles
============

The docker images for Eclipse CDT's [Jenkins instance](https://ci.eclipse.org/cdt/) are stored at [quay.io](https://quay.io/organization/eclipse-cdt)
and built using the following scripts.

build-images.sh
===============

Builds the images locally.

deploy-images.sh
================

Builds images (from cache), uploads them to quay.io/eclipse-cdt namespace and then
updates all the Jenkinsfile and yaml files to refer to these new images.
