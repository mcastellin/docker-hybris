#!/bin/bash -e

BASEDIR="$(dirname "$0")/.."
BASENAME=$(basename "$0")
# Default values for image creation
COMMERCE_SUITE_FILE= # mandatory
RECIPE=b2c_acc
DOCKER_IMAGE_NAME_W_VERSION=ydocker:latest

function read_options() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --bundle)
        shift; COMMERCE_SUITE_FILE=$(basename $1)
        ;;
      --recipe)
        shift; RECIPE=$1
        ;;
      --name)
        shift; DOCKER_IMAGE_NAME_W_VERSION="$1"
        ;;
      *)
       echo "Not a valid option: \"$1\". Run \"$BASENAME help\" for more information"
       return 1
        ;;
    esac
    shift
  done
}

function build_image() {
  # Inputs validation
  if [ -z $COMMERCE_SUITE_FILE ]; then
    echo "Cannot build Hybris image. \"--bundle\" parameter is mandatory.  Run \"$BASENAME help\" for more information"
    return 1
  elif [ ! -f "$BASEDIR/bundles/$COMMERCE_SUITE_FILE" ]; then
    echo "$BASEDIR/bundles/$COMMERCE_SUITE_FILE could not be found or is not a regular file"
    return 1
  fi

  # building image from project home directory
  cd $BASEDIR
  echo "Building hybris image with the following parameters:"
  printf "  --bundle=bundles/$COMMERCE_SUITE_FILE\n  --recipe=$RECIPE\n  --name=$DOCKER_IMAGE_NAME_W_VERSION"
  echo ""

  docker build \
    --build-arg COMMERCE_SUITE_FILE="bundles/$COMMERCE_SUITE_FILE" \
    --build-arg RECIPE="$RECIPE" \
  -t "$DOCKER_IMAGE_NAME_W_VERSION" .
}

if [[ "$1" = "help" || "$1" = "h" ]]; then
  # TODO: provide a properly formatted command-line help. Now just printing README.md
  cat $BASEDIR/README.md
else
  read_options $@
  build_image
fi

echo ""
echo "Done."
