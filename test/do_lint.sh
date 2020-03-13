#!/bin/bash -e

### Run linting for all Dockerfiles defined in dockerfiles.list

BASEDIR="$(dirname "$0")"

dofiles=$(
while read line
do 
  echo -n " ${line}"
done < $BASEDIR/dockerfiles.list)

hadolint ${dofiles}
