#!/bin/bash -e

BASEDIR="$(dirname "$0")"
BASENAME=$(basename "$0")

DOCKER_BASE_IMAGE_NAME=ybase
DOCKER_IMAGE_TAG=latest

# Mandatory parameters to run the build
COMMERCE_BUNDLE_ZIPFILE=$1

function bundle_installation() {
  echo "Remving existing target directory..."
  rm -rf $BASEDIR/target/ || true
  mkdir $BASEDIR/target/

  echo "Unpacking Hybris bundle ${COMMERCE_BUNDLE_ZIPFILE}"
  unzip $COMMERCE_BUNDLE_ZIPFILE "hybris/*" -d $BASEDIR/target/
  cp -r $BASEDIR/setup-bin $BASEDIR/target/
}

function build_base_image() {
  docker build \
    --file $BASEDIR/Dockerfile \
    -t ${DOCKER_BASE_IMAGE_NAME}:${DOCKER_IMAGE_TAG} \
    --no-cache \
    $BASEDIR
}

if [ ! -f "$COMMERCE_BUNDLE_ZIPFILE" ]; then
  echo "${COMMERCE_BUNDLE_ZIPFILE} is not a regular file. Exiting."
  exit 1
fi

bundle_installation
build_base_image

echo "Base image  ${DOCKER_BASE_IMAGE_NAME}:${DOCKER_IMAGE_TAG} created."
