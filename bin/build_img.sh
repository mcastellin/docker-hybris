#!/bin/bash -e

#############################################################################################
# Builds SAP Commerce Docker images 
# This script builds two docker images as a result
# - ybase: this is the base image that contains the unpacked SAP Commerce bundle plus the 
#   installation scripts.
# - ycommerce: the final image built on top of the latest ybase, contains SAP Commerce 
#   customizations and source code. This final image can actually run the SAP Commerce platform.
#############################################################################################

BASEDIR="$(dirname "$0")/.."
BASENAME=$(basename "$0")

DOCKER_IMAGE_NAME=ycommerce
DOCKER_IMAGE_TAG=latest

if [ -z $1 ]; then
  #TODO: provide help command if parameter missing??? 
  echo "Cannot build Hybris image. COMMERCE_BUNDLE_ZIPFILE argument is mandatory."
  return 1
elif [[ "$1" = "help" || "$1" = "h" ]]; then
  echo "
TODO: should provide useful help section for this command in the future.
  "
  exit 0
fi

$BASEDIR/ybase/build_img.sh $1

#TODO: build actualy hybris image with customization

echo ""
echo "Done."
