#!/bin/bash -e 
BASEDIR="$(dirname "$0")"
BASENAME=$(basename "$0")

## Result verification call: 
## $1 = actual result
## $2 = expected result
## $3 = error message
function verify_result() {
  if [[ "$1" = "$2" ]]; then
    return 0
  else
    echo ""
    echo "FAILED: $3. Expected [$2], actual [$1]"
    return 1
  fi
}

echo "Running tests for ybase docker image generation"

## Generating ybase docker image
$BASEDIR/../ybase/build_img.sh $BASEDIR/sap-commerce_testbundle.zip

## Trying to run the resulting container and print some environment variables
OUTPUT=$(docker run --rm \
  ybase:latest \
  bash -c 'echo "$PLATFORM_HOME"')
verify_result "$OUTPUT" "/opt/hybris/bin/platform" "PLATFORM_HOME variable is not set in container"

