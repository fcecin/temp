#!/bin/bash

GENESIS_FILE="genesis.json"
COMETBFT_DIR=$(pwd)

# Check if genesis.json file exists in the current directory
if [ ! -f "$COMETBFT_DIR/$GENESIS_FILE" ]; then
  echo "Error: $GENESIS_FILE not found in the current directory."
  exit 1
fi

# Loop through all nxxx directories
for NODE_DIR in "$COMETBFT_DIR"/n*/; do
  CONFIG_DIR="${NODE_DIR}config"

  if [ ! -d "$CONFIG_DIR" ]; then
    echo "Error: config directory not found in $NODE_DIR"
    exit 1
  fi
  
  # Copy genesis.json to the config directory
  cp "$COMETBFT_DIR/$GENESIS_FILE" "$CONFIG_DIR/$GENESIS_FILE"
  
  if [ $? -ne 0 ]; then
    echo "Error: failed to copy $GENESIS_FILE to $CONFIG_DIR"
    exit 1
  fi
done

echo "Copied $GENESIS_FILE to all nxxx/config directories."
