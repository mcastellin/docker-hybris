#!/bin/bash -e 
BASEDIR="$(dirname "$0")"
BASENAME=$(basename "$0")

source $BASEDIR/_framework.sh

echo "Running tests for ybase docker image generation"

## Generating ybase docker image
$BASEDIR/../ybase/build_img.sh $BASEDIR/sap-commerce_testbundle.zip

## Trying to run the resulting container and print some environment variables
OUTPUT=$(docker run --rm \
  ybase:latest \
  bash -c 'echo "$PLATFORM_HOME"')
verify_result "$OUTPUT" "/opt/hybris/bin/platform" "PLATFORM_HOME variable is not set in container"

