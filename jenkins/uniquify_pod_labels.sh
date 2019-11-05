#!/bin/bash

set -eux

shorthash=$(git rev-parse --short HEAD)
for file in `find * -name '*.Jenkinsfile'`; do
    nameonly=$(echo $file | sed -es,.Jenkinsfile,, -es,.*/,,)
    echo $file " --> " $nameonly
    sed -i "s#label .*#label '${nameonly}-${shorthash}'#" $file
    git add $file
done

git commit -m"Update labels to pods based on commit $shorthash"
echo "The .Jenkinsfiles have been updated, now Push!"
