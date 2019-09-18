#!/bin/bash

set -u # run with unset flag error so that missing parameters cause build failure
set -e # error out on any failed commands
set -x # echo all commands used for debugging purposes

SSH="ssh -o StrictHostKeyChecking=no genie.cdt@projects-storage.eclipse.org"
DOWNLOAD=/home/data/httpd/download.eclipse.org/tools/cdt/$RELEASE_OR_BUILD/$MINOR_VERSION/$MILESTONE
ARTIFACTS=https://ci.eclipse.org/cdt/job/$CDT_JOB_NAME/$CDT_BUILD_NUMBER/artifact
INDEX_PHP_FOR_RCP=scripts/cdt-standalone-php-template

if [ "$PROJECT" == "cdt" ]; then
    ARTIFACTS_REPO_TARGET=$ARTIFACTS/releng/org.eclipse.cdt.repo/target
elif [ "$PROJECT" == "tools.templates" ]; then
    ARTIFACTS_REPO_TARGET=$ARTIFACTS/repo/target
elif [ "$PROJECT" == "launchbar" ]; then
    ARTIFACTS_REPO_TARGET=$ARTIFACTS/repo/target
else
    echo "Missing repo location of $PROJECT"
    exit 1
fi

echo Using download location root of $DOWNLOAD
echo Using artifacts location root of $ARTIFACTS

echo Testing to make sure we are publishing to a new directory
$SSH "test ! -e $DOWNLOAD"

echo Testing to make sure artifacts location is sane
wget -q --output-document=/dev/null  $ARTIFACTS

ECHO=echo
if [ "$DRY_RUN" == "false" ]; then
   ECHO=""
else
    echo Dry run of build:
fi

$ECHO $SSH "mkdir -p $DOWNLOAD"

$ECHO $SSH "cd $DOWNLOAD && \
    wget -q $ARTIFACTS_REPO_TARGET/repository/*zip*/repository.zip && \
    unzip -q repository.zip && \
    mv repository/* . && \
    rm -r repository repository.zip"

$ECHO $SSH "cd $DOWNLOAD && \
    wget -q $ARTIFACTS_REPO_TARGET/org.eclipse.$PROJECT.repo.zip && \
    mv org.eclipse.$PROJECT.repo.zip $MILESTONE.zip"

# promote standalone debugger
if [ "$PROJECT" == "cdt" ] && [ "$STANDALONE" == "true" ]; then
    $ECHO $SSH "mkdir -p $DOWNLOAD/rcp"

    $ECHO $SSH "cd $DOWNLOAD/rcp && \
        wget -q $ARTIFACTS/debug/org.eclipse.cdt.debug.application.product/target/products/*zip*/products.zip && \
        unzip -q products.zip && \
        mv products/* ."

    if [ "$ECHO" == "echo" ]; then
        # if there is a better way to handle echoing the pipeline, let me (Jonah) know
    $ECHO Setting up index.php pipeline
    else
        cat $INDEX_PHP_FOR_RCP | sed "-es,CDT 9.4.0,$(echo $MILESTONE | sed '-es@cdt-@CDT @')," | $SSH "cat - > $DOWNLOAD/rcp/index.php"
    fi
    $ECHO $SSH "cd $DOWNLOAD/rcp && \
        rm -r products products.zip"

    $ECHO $SSH "mkdir $DOWNLOAD/rcp-repository"
    $ECHO $SSH "cd $DOWNLOAD/rcp-repository && \
        wget -q $ARTIFACTS/debug/org.eclipse.cdt.debug.application.product/target/repository/*zip*/repository.zip && \
        unzip -q repository.zip && \
        mv repository/* . && \
        rm -r repository repository.zip"
fi
