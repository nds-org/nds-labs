#!/bin/bash

# clean up existing container

echo "stopping/removing existing container..."

docker kill master &>/dev/null
docker rm master &>/dev/null

echo "starting new container..."

# -d detaches (background)
docker run --name master -d -p 2222:22 ndslabs/master

echo "new container started"

