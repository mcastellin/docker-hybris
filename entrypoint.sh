#!/bin/bash
cd /opt/hybris/bin/platform/

. ./setantenv.sh

if [[ ! -z $ANT_TASKS ]]
then
  echo "Executing custom build tasks: $ANT_TASKS"
  ant $ANT_TASKS
else
  echo "Executing default build tasks: clean customize all"
  ant clean customize all
fi

./hybrisserver.sh
