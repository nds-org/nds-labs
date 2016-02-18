# Clowder in Kubernetes
A set of configuration files / images to deploy Clowder in a Kubernetes Cluster.

# Getting Started
Build and run the NDSDEV image as described here: https://github.com/nds-org/nds-labs/tree/v2/devtools/ndsdev 

Once NDSDEV is running, you should be inside of a docker container running everything that you should need to develop NDS Labs.

Now we will need a blank kubernetes cluster running. Simply run the script provided here:
~~~
./cluster/k8s/localdev/kube-up-local.sh
~~~

Docker should download all of the required images from Google and run them as containers.

To verify that your cluster is up and running, you can run:
~~~
kubectl get pods
~~~

# Starting Clowder
These images should all be pushed to docker hub. Simply running the following command should pull the necessary images.

Running the start script will bring up clowder. Be sure to give it a space-separated list of plugins / extractors that you would like to bring up:
~~~
cd services/ncsa/clowder/
./start-clowder.sh <plugin1> <plugin2> ...
~~~

Accepted plugin values can be found below:
* elasticsearch
* plantcv
* image-preview
* video-preview

NOTE: Specifiying extractors automatically starts RabbitMQ. Otherwise, RabbitMQ will not be started.

Optional arguments:
* -w : wait for service dependencies before continuing startup

# Stopping Clowder
Simply run the stop script to stop clowder:
~~~
./stop-clowder.sh
~~~

You can optionally specify the **-m** parameter to stop everything but MongoDB.

This can be useful for preserving credentials, so that you do not need to re-signup for Clowder whenever you restart things.

# Tips and Tricks
Included in **${PROJECT_ROOT}/cluster/k8s/localdev/** are several exceedingly simple scripts to aid in debugging inside of pods.

These scripts were written to aid in debugging failing pods, which have a very limited timing window where you can read their logs. With the replication controllers creating pods that are named from a template, this can be very frustrating.

## kube-logs.sh <container name>
Display the logs of a container who shares the same name (template) as its pod.
~~~
./kube-logs.sh rabbitmq
~~~

## kube-exec.sh <container name>
Execute an arbitrary command on a container who shares the same name as its pods.
~~~
./kube-exec.sh mongo "curl -L http://${RABBITMQ_PORT_5672_TCP_ADDR}:${RABBITMQ_PORT_5672_TCP_PORT}"
~~~

## kube-env.sh <container name>
Print all enviornment variables present in the given container who shares the same name as its pod.
~~~
./kube-env.sh clowder
~~~

# Test Cases

## Docker Image Build
* From **services/ncsa/clowder/dockerfiles**, run the **make** command.
* You should see the images start building from the Dockerfiles present.
* Images that will be built include:
  * python-base
  * clowder
  * image-preview
  * video-preview
  * plantcv

**WARNING**: plantcv may take up to 25 minutes to complete its build. Plan accodingly.

## Basic Clowder Startup
* Run **. ./start-clowder.sh** with no arguments to spin up a vanilla Clowder, with only a MongoDB instance attached.
* Navigate your browser to **http://YOUR_OPENSTACK_IP:30291**. You should see the Clowder homepage.
* Verify MongoDB attachment by navigating to **http://YOUR_OPENSTACK_IP:30291/api/status**.
  * You should see **mongodb: true** listed under the "plugins" section.

## Account Registration
* Start Clowder (as described above)
* At the top right of the page, click Login and then choose **Sign Up** on the bottom of the panel.
* Enter your e-mail address in the box and press **Submit**. 
  * You should receive an e-mail with a link to confirm your e-mail address.'
* Click the link in the e-mail to be brought back to Clowder.
* Enter your First/Last name, enter/confirm your desired password, then click **Submit**.
* You should now be able to log in with the credentials that you have entered (email / password).

## Create a Dataset / Upload a File
* After registering for an account (see above), create a new dataset by choosing **Datasets > Create** from the navbar at the top of the page.
* Choose a picture file to upload to this dataset. The contents of the picture do not matter.
* After choosing **Start Upload**, check the logs of the mongo container and you should see

## Extractor(s)
Now that you've seen the basic setup, let's try something a little more complex:

* Stop any running Clowder / plugin instances: **. ./stop-clowder.sh -m**
* Restart Clowder with some extractors: **. ./start-clowder.sh -w image-preview plantcv video-preview**
  * The script should automatically start RabbitMQ for you as well, since you have specified that you would like to utilize extractors.
* Wait for everything to finish starting everything up (this may take up to ~1 minute)
* Once Clowder starts, verify that the extractors are present by navigating to **http://YOUR_OPENSTACK_IP:30291/api/status**
  * You should see **rabbitmq: true** listed under the "plugins" section.
  * You should see the extractors you specified listed at the bottom
* Create a Dataset and upload a file as described above.
  * View http://CLOWDER_IP/admin/extractions in your browser to verify that the extractors are working.
  * If anything strange appears on the UI, check the log(s) of each extractor and you should see it doing work on the file(s) you chose to upload

## Text-Based Search (ElasticSearch)
* Stop any running Clowder / plugin instances: **. ./stop-clowder.sh -m**
* Restart Clowder with elasticsearch enabled: **. ./start-clowder.sh elasticsearch**
* Once Clowder starts, verify that elasticsearch is enabled by navigating to **http://YOUR_OPENSTACK_IP:30291/api/status**
  * You should see **elasticsearch: true** listed under the "plugins" section.
  * You should see a "Search" box at the top-right of the Clowder UI. This indicates that elasticsearch is enabled.
* After uploading a file (as described above), attempt to search for the file extensions, such as "jpg" or "png".
  * You should see the file that you uploaded listed under the results of the search.
