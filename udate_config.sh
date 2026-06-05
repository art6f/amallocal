#!/bin/bash

# check for the existing config
FRESH_SETUP=false
if [ ! -f '.env' ]; then
    echo "No .env file, using default .dist..."
    cp .env.dist .env
    FRESH_SETUP=true
fi

# update key
if [ $FRESH_SETUP == "true" ]; then
    echo "Update WebUI secret key $RND_KEY"
    
    RND_KEY=$(head -n 128 /dev/random | sha256sum | cut -d' ' -f1);
    sed -i -e "s/WEBUI_SECRET_KEY=.*/WEBUI_SECRET_KEY=$RND_KEY/g" ".env"
fi

echo "Detecting available CPU cores..."
CPU_CORES=$(getconf _NPROCESSORS_ONLN)
if [[ $CPU_CORES -lt 1 ]]; then
    echo "Error retrieving CPU cores number, expected positive number, received: '$CPU_CORES'"
    exit 1;
fi
echo "Host machine has $CPU_CORES cores"

# Use the half of the cores
echo "Calculation how many cores to use..."
TARGET_CORES=$((CPU_CORES / 2))
if [[ $TARGET_CORES -lt 1 ]]; then
    echo "Error calculating cores to use, expected positive number, received: '$TARGET_CORES'"
    exit 1;
fi
echo "Using $TARGET_CORES for ollama..."

sed -i -e "s/OLLAMA_NUM_PARALLEL=.*/OLLAMA_NUM_PARALLEL=$TARGET_CORES/g" ".env"
echo "Config updated"


# MacOS/BSD compatibility cleanup
rm -f .env-e