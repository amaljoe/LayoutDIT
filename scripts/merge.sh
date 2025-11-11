#!/bin/bash

# Usage: ./squash_merge.sh "Your commit message here"

# Exit if any command fails
set -e

# Check if commit message is provided
if [ -z "$1" ]; then
  echo "❌ Error: Commit message is required."
  echo "Usage: $0 \"Your commit message\""
  exit 1
fi

COMMIT_MSG="$1"

# Step 0: Ensure no uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
  echo "⚠️  You have uncommitted changes."
  echo "💾 Staging and committing them as 'WIP (auto-commit by script)'..."
  git add .
  git commit -m "WIP (auto-commit by squash_merge.sh)"
fi

# Step 1: Checkout main
echo "🔀 Switching to main..."
git checkout main

# Step 2: Update main
echo "🔄 Pulling latest changes from origin/main..."
git pull origin main

# Step 3: Squash and merge dev into main
echo "🔁 Squash merging dev into main..."
git merge --squash dev

echo "✅ Committing squash merge..."
git commit -m "$COMMIT_MSG"

# Step 4: Push to main
echo "🚀 Pushing to origin/main..."
git push origin main

# Step 5: Delete and recreate dev from updated main
echo "🗑️ Deleting old dev branch..."
git branch -D dev

echo "🌱 Recreating dev branch from main..."
git checkout -b dev
git push origin dev --force

echo "🎉 Done! Clean dev created from updated main."
