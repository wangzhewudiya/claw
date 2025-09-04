#!/bin/bash

# Check if GITHUB_URL environment variable is set
if [ -z "$GITHUB_URL" ]; then
    echo "Error: GITHUB_URL environment variable is not set"
    exit 1
fi

# Remove cache directory
rm -rf /root/app

# Clone the repository
git clone "$GITHUB_URL" /root/app

# Change directory to the cloned repository
cd /root/app || exit

# Make claw.sh executable and run it
chmod -R 777 claw.sh
bash claw.sh
