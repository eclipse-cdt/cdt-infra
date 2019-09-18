#!/bin/bash

set -u # run with unset flag error so that missing parameters cause build failure
set -e # error out on any failed commands
set -x # echo all commands used for debugging purposes

SSH="ssh -o StrictHostKeyChecking=no genie.cdt@projects-storage.eclipse.org"
SCP="scp -o StrictHostKeyChecking=no"
SSHUSER="genie.cdt@projects-storage.eclipse.org"
DOWNLOAD=/home/data/httpd/download.eclipse.org/tools/cdt

ECHO=echo
if [ "$DRY_RUN" == "false" ]; then
   ECHO=""
else
    echo Dry run of build:
fi

# Rather than putting in infra/coding to make this a fully generic script with parameters,
# just list out what needs to be copied where
$ECHO $SCP ./download/releases/9.7/* "${SSHUSER}:${DOWNLOAD}/releases/9.7/"
$ECHO $SCP ./download/releases/9.8/* "${SSHUSER}:${DOWNLOAD}/releases/9.8/"
$ECHO $SCP ./download/releases/9.9/* "${SSHUSER}:${DOWNLOAD}/releases/9.9/"
