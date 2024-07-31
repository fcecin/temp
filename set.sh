#!/bin/bash

# This script sets a property value across all config.toml files
#   of all n[xx]/ nodes.

# Check if the correct number of arguments are provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 <property_name> [<property_value>]"
  exit 1
fi

PROPERTY_NAME=$1
PROPERTY_VALUE=$2
COMETBFT_DIR=$(pwd)

# Loop through all nxxx directories
for CONFIG_FILE in "$COMETBFT_DIR"/n*/config/config.toml; do
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.toml not found in ${CONFIG_FILE%/config/config.toml}"
    exit 1
  fi
  
  # Check if the property exists in the file
  MATCH_COUNT=$(grep -c "^${PROPERTY_NAME} =" "$CONFIG_FILE")
  
  if [ "$MATCH_COUNT" -eq 1 ]; then
    if [ -z "$PROPERTY_VALUE" ]; then
      # Read and print the property value
      VALUE=$(grep "^${PROPERTY_NAME} =" "$CONFIG_FILE" | sed "s/^${PROPERTY_NAME} = //")
      echo "Property ${PROPERTY_NAME} in $CONFIG_FILE: $VALUE"
    else
      # Handle setting the property value literally
      if [[ "$PROPERTY_VALUE" =~ ^\".*\"$ ]]; then
        sed -i "s|^${PROPERTY_NAME} = .*|${PROPERTY_NAME} = ${PROPERTY_VALUE}|" "$CONFIG_FILE"
      else
        sed -i "s|^${PROPERTY_NAME} = .*|${PROPERTY_NAME} = ${PROPERTY_VALUE}|" "$CONFIG_FILE"
      fi

      if [ $? -ne 0 ]; then
        echo "Error: failed to update ${PROPERTY_NAME} in $CONFIG_FILE"
        exit 1
      fi
    fi
  elif [ "$MATCH_COUNT" -gt 1 ]; then
    echo "Error: property ${PROPERTY_NAME} appears multiple times in $CONFIG_FILE, which is ambiguous."
  else
    echo "Property ${PROPERTY_NAME} not found in $CONFIG_FILE"
  fi
done

if [ -n "$PROPERTY_VALUE" ]; then
  echo "Updated ${PROPERTY_NAME} to ${PROPERTY_VALUE} in all nxxx/config/config.toml files where the property exists."
fi
