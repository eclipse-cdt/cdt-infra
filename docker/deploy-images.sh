#!/usr/bin/env bash

set -eux

if ! git diff-index HEAD --quiet; then
    echo "git tree is dirty, please commit changes before deploying images"
    exit 1
fi

namespace=${1:-quay.io/eclipse-cdt}
shorthash=$(git rev-parse --short HEAD)
toplevel=$(git rev-parse --show-toplevel)

images="cdt-infra-eclipse-full:ubuntu-16.04 cdt-infra-platform-sdk:sdk4.9-ubuntu-16.04"

$toplevel/docker/build-images.sh

for image in $images; do
    docker tag $image ${namespace}/${image}-${shorthash}
    docker push ${namespace}/${image}-${shorthash}
done

echo "The following images have been pushed."
for image in $images; do
    hashname=$(docker inspect --format='{{index .RepoDigests 0}}' $image)
    echo $image "-->" $hashname
    nameonly=$(echo $image | sed -es,:.*,,)
    find $toplevel -name \*\.Jenkinsfile -or -name \*\.yaml | while read file; do
        sed -i "s#image: $namespace/$nameonly[:@].*#image: $hashname#" $file
        git add $file
    done
done
echo "Finished pushing to $namespace with tag hash $shorthash"
git commit -m"Update images to Dockerfiles from commit $shorthash"
echo "The .yaml and .Jenkinsfiles have been updated to new image and committed, now Push!"
