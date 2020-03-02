#!/bin/bash

#############################################################################################
# Builds SAP Commerce Docker images 
# This script builds two docker images as a result
# - ybase: this is the base image that contains the unpacked SAP Commerce bundle plus the 
#   installation scripts.
# - ycommerce: the final image built on top of the latest ybase, contains SAP Commerce 
#   customizations and source code. This final image can actually run the SAP Commerce platform.
#############################################################################################

DOCKER_BASE_IMAGE_NAME=ybase
DOCKER_IMAGE_NAME=ycommerce
DOCKER_IMAGE_TAG=latest

# Mandatory parameters to run the build
COMMERCE_BUNDLE_ZIPFILE=$1

function bundle_installation() {
  echo "Remving existing target directory..."
  rm -rf target/ || true
  mkdir target/

  #TODO: check file actually exists
  echo "Unpacking Hybris bundle ${COMMERCE_BUNDLE_ZIPFILE}"
  unzip $COMMERCE_BUNDLE_ZIPFILE "hybris/*" -d target/
  cp -r setup-bin target/
}

function build_base_image {
  docker build \
    -t ${DOCKER_BASE_IMAGE_NAME}:${DOCKER_IMAGE_TAG} \
    .
}

if [ -z $COMMERCE_BUNDLE_ZIPFILE ]; then
  #TODO: provide help command if parameter missing??? 
  echo "Cannot build Hybris image. COMMERCE_BUNDLE_ZIPFILE argument is mandatory."
  return 1
fi
#TODO: check for installation bundle existence

bundle_installation
build_base_image

#TODO: build actualy hybris image with customization

echo ""
echo "Done."
