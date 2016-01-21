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

mkdir ~/kubectl
cd ~/kubectl
curl -L "https://storage.googleapis.com/kubernetes-release/release/v1.1.3/bin/linux/amd64/kubectl" > ~/kubectl/kubectl
export PATH=$PATH:`pwd`
chmod +x ~/kubectl/kubectl
