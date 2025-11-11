#!/bin/bash

# List all Python-related processes, excluding the grep and this script
pids=$(ps aux | grep '[p]ython' | grep -v jupyter | awk '{print $2}')

if [ -z "$pids" ]; then
    echo "No Python processes found."
    exit 0
fi

echo "Killing the following PIDs:"
echo "$pids"

# Kill the processes
for pid in $pids; do
    kill -9 $pid && echo "Killed $pid" || echo "Failed to kill $pid"
done
