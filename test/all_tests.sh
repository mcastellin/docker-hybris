#!/bin/bash

BASEDIR="$(dirname "$0")"
BASENAME=$(basename "$0")

function check_results() {
  if [[ "$?" != 0 ]]; then
    echo ""
    echo "TEST FAILED."
    exit 1
  fi
}

echo "Running all unit tests for docker-hybris\n"
echo "" 

${BASEDIR}/ybase_generation_tests.sh || check_results
${BASEDIR}/full_generation_tests.sh || check_results

echo ""
echo "SUCCESS."
