#!/bin/bash

# Any errors will cause this script to fail immediately
# set -e

# Run the base single-node setup as described here: https://github.com/kubernetes/kubernetes/blob/release-1.1/docs/getting-started-guides/docker.md/
docker run --net=host -d gcr.io/google_containers/etcd:2.0.12 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
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
    /hyperkube kubelet --containerized --hostname-override="127.0.0.1" --address="0.0.0.0" --api-servers=http://localhost:8080 --config=/etc/kubernetes/manifests
docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.1.3 /hyperkube proxy --master=http://127.0.0.1:8080 --v=2

# Save the workdir so we can return to it after execution
PREV_PATH=`pwd`

# Install kubectl
mkdir -p ~/kubectl
cd ~/kubectl
curl -L "https://storage.googleapis.com/kubernetes-release/release/v1.1.3/bin/linux/amd64/kubectl" > ~/kubectl/kubectl
export PATH=$PATH:`pwd`
chmod +x ~/kubectl/kubectl

# Clone the repo containing the files required to build clowder
cd /nds && \ 
    git clone https://opensource.ncsa.illinois.edu/bitbucket/scm/bd/dockerfiles.git 

# Build required docker images
cd /nds/dockerfiles/clowder

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
kubectl run clowder_mongodb --image=mongo:latest
kubectl run clowder_rabbitmq --image=rabbitmq:management
kubectl expose rc clowder_rabbitmq --port=5672
kubectl expose rc clowder_rabbitmq --port=15672

# Now run the extractors, so they can connect to RabbitMQ
kubectl run clowder_image-preview --image=clowder/image-preview
kubectl run clowder_video-preview --image=clowder/video-preview
kubectl run clowder_plantcv --image=clowder/plantcv

# Finally, run clowder itself
kubectl run clowder_clowder --image clowder/clowder
kubectl expose rc clowder_clowder --port=9000


