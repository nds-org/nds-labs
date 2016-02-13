#!/bin/bash
# set -e

# Clowder URI
export CLOWDER_ADDR=10.0.0.57
export CLOWDER_PORT=9000

# Tool Server URI
export TOOLSRV_ADDR=10.0.0.120
export TOOLSRV_PORT=8082

# Request metadata
export CLOWDER_KEY=r1ek3rs
export TOOLSRV_TARGET_DATASET=56ba103be4b01696e6f1cd07

echo "Requesting dataset ${TOOLSRV_TARGET_DATASET} using key=${CLOWDER_KEY}"
echo "${CLOWDER_ADDR}:${CLOWDER_PORT} <-> ${TOOLSRV_ADDR}:${TOOLSRV_PORT}"
echo ""
