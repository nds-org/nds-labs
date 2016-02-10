# Clowder in Kubernetes


## Getting Started
Build and run the NDSDEV image as described here: https://github.com/nds-org/nds-labs/tree/lambert-dev/devtools/ndsdev 

Once NDSDEV is running, you should be inside of a docker container running everything that you should need to develop NDS Labs.

You should have already had to clone the repo to build NDSDEV, so change to the **services/ncsa/clowder/** directory (this folder):
~~~
cd services/ncsa/clowder/
~~~

This folder will be your working directory. Here you will see a Makefile with two distinct options for building up the necessary Clowder docker images.

### From Docker Hub (default)
Once we have our docker hub practices settled, we can push these images up to Docker Hub and use that to circulate them:
~~~
make all
~~~

Until then, building from source should work.

### From Source
Execute the following command to checkout the **dockerfiles.git** repo and build the images pertaining to Clowder:
~~~
make all-from-src
~~~

## Overview
Dev Mode:
~~~
kubectl create -f pods/clowder-monolith-pod.yaml
~~~

Production Mode:
~~~
kubectl create -f services/
kubectl create -f controllers/
~~~

## Tips and Tricks
Included in **${PROJECT_ROOT}/cluster/k8s/localdev/** are several exceedingly simple scripts to aid in debugging inside of pods.

These scripts were written to aid in debugging failing pods, which have a very limited timing window where you can read their logs. With the replication controllers creating pods that are named from a template, this can be very frustrating.

### . ./logs.sh <pod/container name>
Display the logs of a container who shares the same name (template) as its pod.
~~~
. ./logs.sh clowder-rabbitmq
~~~

### . ./exec.sh <pod/container name>
Execute an arbitrary command on a container who shares the same name as its pods.
~~~
. ./exec.sh clowder-mongodb "curl -L http://10.0.0.100:15672"
~~~

### . ./env.sh <pod/container name>
Print all enviornment variables present in the given container who shares the same name as its pod.
~~~
. ./env.sh clowder-clowder
~~~
