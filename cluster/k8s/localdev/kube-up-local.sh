#!bin/bash

# Run the base single-node setup as described here: https://github.com/kubernetes/kubernetes/blob/release-1.1/docs/getting-started-guides/docker.md/
docker run --net=host -d gcr.io/google_containers/etcd:2.0.12 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
docker run     --volume=/:/rootfs:ro     --volume=/sys:/sys:ro     --volume=/dev:/dev     --volume=/var/lib/docker/:/var/lib/docker:ro     --volume=/var/lib/kubelet/:/var/lib/kubelet:rw     --volume=/var/run:/var/run:rw     --net=host     --pid=host     --privileged=true     -d     gcr.io/google_containers/hyperkube:v1.1.3     /hyperkube kubelet --containerized --hostname-override=127.0.0.1 --address=0.0.0.0 --api-servers=http://127.0.0.1:8080 --config=/etc/kubernetes/manifests
docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v1.1.3 /hyperkube proxy --master=http://127.0.0.1:8080 --v=2
