#!/bin/bash

# Define variables
URL="https://github.com/cometbft/cometbft/releases/download/v0.38.10/cometbft_0.38.10_linux_amd64.tar.gz"
TEMP_DIR="/tmp/cometbft_download"
TAR_FILE="$TEMP_DIR/cometbft_0.38.10_linux_amd64.tar.gz"
CURRENT_DIR=$(pwd)

# Create a temporary directory
mkdir -p $TEMP_DIR

# Download the file to the temporary directory
curl -L $URL -o $TAR_FILE

# Extract the tar.gz file in the temporary directory
tar -xzf $TAR_FILE -C $TEMP_DIR

# Copy the extracted cometbft file to the current directory
cp $TEMP_DIR/cometbft $CURRENT_DIR

# Clean up
rm -rf $TEMP_DIR

echo "cometbft has been copied to $CURRENT_DIR"
