#!/bin/bash -e 
BASEDIR="$(dirname "$0")"
BASENAME=$(basename "$0")

echo "Running tests for ybase docker image generation"

$BASEDIR/../ybase/build_img.sh $BASEDIR/sap-commerce_testbundle.zip

exit 0
