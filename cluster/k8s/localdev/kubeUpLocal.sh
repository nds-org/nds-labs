#!/bin/bash

# Any errors will cause this script to fail immediately
# set -e

# Pull IP/hostname from first argument
DEFAULT_IP_ADDR=127.0.0.1
ip_addr=${1:-$DEFAULT_IP_ADDR}
echo "Starting Kubernetes cluster at ${ip_addr}"

# Run the base single-node setup as described here: https://github.com/kubernetes/kubernetes/blob/release-1.1/docs/getting-started-guides/docker.md/
docker run --net=host -d gcr.io/google_containers/etcd:2.0.12 /usr/local/bin/etcd --addr=${ip_addr}:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
docker run \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    -d \
    gcr.io/google_containers/hyperkube:v1.1.3 \
    /hyperkube kubelet --containerized --hostname-override="${ip_addr}" --address="0.0.0.0" --api-servers=http://${ip_addr}:8080 --config=/etc/kubernetes/manifests
docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.1.3 /hyperkube proxy --master=http://${ip_addr}:8080 --v=2

# Save the workdir so we can return to it after execution
PREV_PATH=`pwd`

# Clone the repo containing the files required to build clowder
cd ~
if [ ! -d "dockerfiles" ]; then
  git clone https://opensource.ncsa.illinois.edu/bitbucket/scm/bd/dockerfiles.git || exit 1
fi

# Build required docker images
cd dockerfiles/clowder || exit 1

echo "Building python-base..."
sleep 2
docker build -t clowder/python-base:latest python-base

echo "Building video-preview..."
sleep 2
docker build -t clowder/video-preview:latest video-preview

echo "Building image-preview..."
sleep 2
docker build -t clowder/image-preview:latest image-preview

echo "Building plantcv..."
sleep 2
docker build -t clowder/plantcv:latest plantcv

echo "Building clowder..."
sleep 2
docker build -t clowder/clowder:latest clowder

# Return to previous pwd
cd $PREV_PATH

# Start containers from official images first
kubectl run clowder-mongodb --image=mongo:latest
kubectl run clowder-rabbitmq --image=rabbitmq:management
kubectl expose rc clowder-rabbitmq --port=5672 --port=15672

# Now run the extractors, so they can connect to RabbitMQ
kubectl run clowder-image-preview --image=clowder/image-preview
kubectl run clowder-video-preview --image=clowder/video-preview
kubectl run clowder-plantcv --image=clowder/plantcv

# Finally, run clowder itself
kubectl run clowder-clowder --image clowder/clowder
kubectl expose rc clowder-clowder --port=9000

