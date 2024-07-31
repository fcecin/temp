#!/bin/bash

# This script resets all n[xxx]/ blockchain nodes to the default, so
#   everything starts from genesis again.

# Default content for priv_validator_state.json
PRIV_VALIDATOR_STATE_CONTENT='{
  "height": "0",
  "round": 0,
  "step": 0
}'

# Iterate over each subdirectory that matches the pattern n*
for NODE_DIR in ./n*/; do
  # Define the path to the data directory
  DATA_DIR="${NODE_DIR}data"
  CONFIG_DIR="${NODE_DIR}config"

  # Check if the data directory exists
  if [ -d "$DATA_DIR" ]; then
    echo "Cleaning data directory for node: $NODE_DIR"
    
    # Remove all files and directories inside the data directory
    rm -rf "$DATA_DIR"/*

    # Recreate priv_validator_state.json with the default content
    echo "$PRIV_VALIDATOR_STATE_CONTENT" > "$DATA_DIR/priv_validator_state.json"
    
    echo "Recreated priv_validator_state.json for node: $NODE_DIR"
  else
    echo "Data directory does not exist for node: $NODE_DIR"
  fi

  # Check if the config directory exists and clean it
  if [ -d "$CONFIG_DIR" ]; then
    echo "Cleaning config directory for node: $NODE_DIR"
    
    # Remove all files with the name prefix write-file-atomic- in the config directory
    find "$CONFIG_DIR" -type f -name 'write-file-atomic-*' -exec rm -f {} +

    # Remove addrbook.json if it exists
    if [ -f "$CONFIG_DIR/addrbook.json" ]; then
      rm -f "$CONFIG_DIR/addrbook.json"
      echo "Removed addrbook.json for node: $NODE_DIR"
    fi
  else
    echo "Config directory does not exist for node: $NODE_DIR"
  fi

  # Remove cometbft.log file if it exists
  LOG_FILE="${NODE_DIR}cometbft.log"
  if [ -f "$LOG_FILE" ]; then
    echo "Removing cometbft.log for node: $NODE_DIR"
    rm -f "$LOG_FILE"
  else
    echo "cometbft.log does not exist for node: $NODE_DIR"
  fi
done

echo "Cleanup completed for all nodes."
