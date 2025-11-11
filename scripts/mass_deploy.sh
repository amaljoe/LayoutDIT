#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "❌ Please provide the experiment folder as the first argument."
  echo "Usage: $0 runners/xtreme-nli-lambda"
  exit 1
fi

experiment_dir="$1"
prefix=$(basename "$experiment_dir")

# Check directory exists
if [ ! -d "$experiment_dir" ]; then
  echo "❌ Directory not found: $experiment_dir"
  exit 1
fi

# Iterate over matching scripts
for script_path in "$experiment_dir"/${prefix}*.sh; do
  if [ -f "$script_path" ]; then
    script_name=$(basename "$script_path")
    echo "🚀 Deploying $script_path ..."
    ./deploy_vela.sh "$script_path" --dont-push --forced
#    ./deploy_pok.sh "$script_path"
  else
    echo "⚠️  Skipping: $script_path not found"
  fi
done

echo "✅ All scripts deployed successfully!"
oc get pods | grep am-