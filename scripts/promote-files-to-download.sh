#!/bin/bash

set -u # run with unset flag error so that missing parameters cause build failure
set -e # error out on any failed commands
set -x # echo all commands used for debugging purposes

SSHUSER="genie.cdt@projects-storage.eclipse.org"
SSH="ssh ${SSHUSER}"
SCP="scp"
DOWNLOAD=/home/data/httpd/download.eclipse.org/tools/cdt

ECHO=echo
if [ "$DRY_RUN" == "false" ]; then
   ECHO=""
else
    echo Dry run of build:
fi

# Rather than putting in infra/coding to make this a fully generic script with parameters,
# just list out what needs to be copied where
$ECHO $SSH mkdir -p "${DOWNLOAD}/releases/latest/"
$ECHO $SCP ./download/releases/latest/* "${SSHUSER}:${DOWNLOAD}/releases/latest/"
$ECHO $SCP ./download/releases/9.7/* "${SSHUSER}:${DOWNLOAD}/releases/9.7/"
$ECHO $SCP ./download/releases/9.8/* "${SSHUSER}:${DOWNLOAD}/releases/9.8/"
$ECHO $SCP ./download/releases/9.9/* "${SSHUSER}:${DOWNLOAD}/releases/9.9/"
$ECHO $SCP ./download/releases/9.10/* "${SSHUSER}:${DOWNLOAD}/releases/9.10/"
$ECHO $SCP ./download/releases/9.11/* "${SSHUSER}:${DOWNLOAD}/releases/9.11/"
$ECHO $SCP ./download/releases/10.0/* "${SSHUSER}:${DOWNLOAD}/releases/10.0/"
$ECHO $SCP ./download/releases/10.1/* "${SSHUSER}:${DOWNLOAD}/releases/10.1/"
$ECHO $SCP ./download/releases/10.2/* "${SSHUSER}:${DOWNLOAD}/releases/10.2/"
$ECHO $SCP ./download/releases/10.3/* "${SSHUSER}:${DOWNLOAD}/releases/10.3/"
$ECHO $SCP ./download/releases/10.4/* "${SSHUSER}:${DOWNLOAD}/releases/10.4/"
$ECHO $SCP ./download/releases/10.5/* "${SSHUSER}:${DOWNLOAD}/releases/10.5/"
