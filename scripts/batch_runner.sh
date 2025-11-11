#!/bin/bash

set -e

# Check argument
if [ -z "$1" ]; then
  echo "❌ Usage: $0 <script_directory>"
  exit 1
fi

SCRIPT_DIR="$1"

# Check if directory exists
if [ ! -d "$SCRIPT_DIR" ]; then
  echo "❌ Directory not found: $SCRIPT_DIR"
  exit 1
fi

LOG_FILE="$SCRIPT_DIR/completed.txt"

shopt -s nullglob  # avoid wildcard errors if no match

for f in "$SCRIPT_DIR"/*.sh; do
  if grep -Fxq "$f" "$LOG_FILE" 2>/dev/null; then
    echo "⏩ Skipping (already completed): $f"
    continue
  fi

  echo "▶️ Running: $f"
  bash "$f"
  echo "$f" >> "$LOG_FILE"
  echo "✅ Completed: $f"
done

echo "🎉 All done!"
