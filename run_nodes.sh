#!/bin/bash

COMETBFT_DIR=$(pwd)
NODE_COUNT=$(ls -d n*/ 2>/dev/null | wc -l)

if [ "$NODE_COUNT" -eq 0 ]; then
  echo "Error: No nodes found. Please run create_nodes.sh first."
  exit 1
fi

for i in $(seq 1 $NODE_COUNT); do
  NODE_DIR="${COMETBFT_DIR}/n${i}"

  # Check if the node directory exists
  if [ ! -d "$NODE_DIR" ]; then
    echo "Error: Node directory $NODE_DIR not found."
    exit 1
  fi

  # Start each node in the background and log to the respective directory
  nohup ./cometbft node --home "$NODE_DIR" --proxy_app=kvstore > "$NODE_DIR/cometbft.log" 2>&1 &
done

echo "Started $NODE_COUNT CometBFT instances with unique ports."
