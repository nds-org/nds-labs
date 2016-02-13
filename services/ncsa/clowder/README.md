# Clowder in Kubernetes
A set of configuration files / images to deploy Clowder in a Kubernetes Cluster.

## Getting Started
Build and run the NDSDEV image as described here: https://github.com/nds-org/nds-labs/tree/v2/devtools/ndsdev 

Once NDSDEV is running, you should be inside of a docker container running everything that you should need to develop NDS Labs.

You should have already had to clone the repo to build NDSDEV, so change to the **services/ncsa/clowder/** directory (this folder):
~~~
cd services/ncsa/clowder/
~~~

This folder will be your working directory. Here you will see a Makefile with two distinct options for building up the necessary Clowder docker images.

### From Docker Hub (default)
These images should all be pushed to docker hub. Simply running the following command should pull the necessary images.
~~~
make all
~~~

NOTE: Kubernetes will perform this step for you if the images that it needs are missing.

### From Source
Execute the following command to checkout the **dockerfiles.git** repo and build the images pertaining to Clowder:
~~~
make all-from-src
~~~

## Starting Clowder
Running the start script will bring up clowder. Be sure to give it a space-separated list of plugins / extractors that you would like to bring up:
~~~
. ./start-clowder.sh <plugin1> <plugin2> ...
~~~

Accepted plugin values can be found below:
* elasticsearch
* plantcv (automatically adds required RabbitMQ)
* image-preview (automatically adds required RabbitMQ)
* video-preview (automatically adds required RabbitMQ)

## Stopping Clowder
Simply run the stop script to stop clowder:
~~~
. ./stop-clowder.sh
~~~

## Tips and Tricks
Included in **${PROJECT_ROOT}/cluster/k8s/localdev/** are several exceedingly simple scripts to aid in debugging inside of pods.

These scripts were written to aid in debugging failing pods, which have a very limited timing window where you can read their logs. With the replication controllers creating pods that are named from a template, this can be very frustrating.

### . ./logs.sh <container name>
Display the logs of a container who shares the same name (template) as its pod.
~~~
. ./logs.sh rabbitmq
~~~

### . ./exec.sh <container name>
Execute an arbitrary command on a container who shares the same name as its pods.
~~~
. ./exec.sh mongo "curl -L http://${RABBITMQ_PORT_5672_TCP_ADDR}:${RABBITMQ_PORT_5672_TCP_PORT}"
~~~

### . ./env.sh <container name>
Print all enviornment variables present in the given container who shares the same name as its pod.
~~~
. ./env.sh clowder
~~~
