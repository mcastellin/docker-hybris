#!/bin/bash

## This framework script contains common functions that are useful for the creation
## of unit tests and automations

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

