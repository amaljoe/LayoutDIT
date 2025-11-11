#!/bin/bash

set -e

# Usage: ./deploy.sh <script_path> [--dont-push] [--forced]

if [ -z "$1" ]; then
  echo "Usage: $0 <script_path> [--dont-push] [--forced]"
  exit 1
fi

RAW_NAME="$1"
YAML_FILE=".helm/vela1_odm.yaml"

# Parse flags
DONT_PUSH=false
FORCED=false

for arg in "$@"; do
  case "$arg" in
    --dont-push)
      DONT_PUSH=true
      ;;
    --forced)
      FORCED=true
      ;;
  esac
done

# Extract script name (basename, no .sh)
BASENAME_WITHOUT_EXT=$(basename "$RAW_NAME" .sh)

# Sanitize Helm release name
SANITIZED=$(echo "$BASENAME_WITHOUT_EXT" | tr '/.' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')
HELM_NAME="am-${SANITIZED}"
HELM_NAME=$(echo "$HELM_NAME" | cut -c1-53)

if [ -z "$HELM_NAME" ]; then
  echo "❌ Invalid Helm release name after sanitization."
  exit 1
fi

# Conditionally commit and push Git changes
if [ "$DONT_PUSH" = false ]; then
  git add .
  git commit -m "deploy: Deploy $RAW_NAME via Helm"
  git push origin main
else
  echo "⚠️ Skipping Git push (--dont-push)"
fi

# Check if Helm release already exists
RELEASE_EXISTS=$(helm list --filter "^${HELM_NAME}$" -q)

if [ -n "$RELEASE_EXISTS" ] && [ "$FORCED" = false ]; then
  echo "⚠️ Helm release '$HELM_NAME' already exists. Use --forced to redeploy."
  exit 0
fi

if [ -n "$RELEASE_EXISTS" ] && [ "$FORCED" = true ]; then
  echo "⚠️ Helm release '$HELM_NAME' already exists. Uninstalling."
  helm uninstall "$HELM_NAME"
  echo "⚠️ Helm release '$HELM_NAME' Uninstalled. Deploy again after sometime."
  exit 0
fi

echo "🚀 Deploying Helm release '$HELM_NAME'..."
helm install "$HELM_NAME" -f "$YAML_FILE" \
  --set-string scriptName="$RAW_NAME" \
  .helm

echo "✅ Deployment complete: $HELM_NAME"
