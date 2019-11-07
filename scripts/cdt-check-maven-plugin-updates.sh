#!/bin/bash

set -u # run with unset flag error so that missing parameters cause build failure
set -e # error out on any failed commands
set -x # echo all commands used for debugging purposes

mvnCommand=${MVN:-mvn}
output=`${mvnCommand} versions:display-plugin-updates -P build-standalone-debugger-rcp -U -B`
echo "${output}"
#filter only updates and show unique
# XXX: Jonah added the exclusion for sonar-maven-plugin as Eclipse's SonarQube installation is not new enough
# XXX: see https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+Maven#AnalyzingwithSonarQubeScannerforMaven-Compatibility
summary=`echo "${output}" | grep "\\->" | grep -v "org.codehaus.mojo:sonar-maven-plugin" | sort | uniq`
echo -e "Summary:\n${summary}"
#remove empty lines and count lines
outdatedNb=`echo "${summary}" | sed '/^\s*$/d' | wc -l`
echo Number of outdated plugins: "${outdatedNb}"
exit ${outdatedNb}
