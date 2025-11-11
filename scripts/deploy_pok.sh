#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <script-name>"
  exit 1
fi

SCRIPT_NAME="$1"
JOB_SUFFIX=$(basename "$SCRIPT_NAME" .sh)
JOB_NAME="am-${JOB_SUFFIX#*-}"

export SCRIPT_NAME JOB_NAME

envsubst < .helm/pok_template.yaml | oc apply -f -
