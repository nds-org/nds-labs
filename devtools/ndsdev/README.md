# NDS Development Environment (NDSDEV)

## Prerequisites
In order to get started developing NDS Labs, you must have an appropriate development environment. We recommend using CoreOS.

At the very least, your enviornment should include Docker. This will allow you to access any build tools you might need without cluttering your host.

### Docker
Docker.io is a containerization technology that is blowing up right now in popularity.

Learn more about how to use Docker: https://docs.docker.com/linux/

### CoreOS
CoreOS is an extremely minimalistic Linux distro. It ships with etcd, docker, and fleetctl (notice: no package manager) with the main idea being that docker containers can provide any type of environment that would suit your current task.

Learn more about what's included in CoreOS: https://coreos.com/using-coreos/

### Allocate VM on OpenStack Nebula (Optional)
Log into Nebula and create a VM under the project NDSLabsDev. Use the image entitled CoreCloud835.

Be sure to select a size (which is paradoxically entitled "flavor").

If you are unsure which to use, you likely should be using "large" or "medium".

#### OpenStack Nebula Security

**DO NOT** forget to generate / import an SSH key for this machine, or else you will never be able to get into it.

Be sure to add **Permissions** to this VM:
* remote SSH
* remote HTTP

### Clone the Source Repo
To start, you will need the code. Clone it and change into the new directory:
~~~
git clone https://github.com/nds-org/nds-labs
cd nds-labs/
~~~

NOTE: Once we have an NDSDEV image circulating (potentially in DockerHub?), this step should no longer be necessary.

### Build (or Remove) NDSDEV Image
Execute the following command at the project root to build up the ndsdev image:
~~~
. ./devtools/ndsdev/ndsdevctl build
~~~

This will create a data container to hold the source code mapped to your host VM. This should allow your code / changes to survive container restarts.

NOTE: It is interesting to note that you should be able to access the data on any volumes defined by the container without it needing to run.

To remove the image built by this step, you can run:
~~~
. ./devtools/ndsdev/ndsdevctl rmi
~~~

### Run (or Remove) NDSDEV Container
You should then be able to run this image using:
~~~
. ./devtools/ndsdev/ndsdevctl run
~~~

Stop the container and remove it from docker (i.e. clean):
~~~
. ./devtools/ndsdev/ndsdevctl rm
~~~

## Usage
To start a stopped NDSDEV container:
~~~
. ./devtools/ndsdev/ndsdevctl start
~~~

To get back to a running instance of NDSDEV:
~~~
. ./devtools/ndsdev/ndsdevctl attach
~~~

Stop the container:
~~~
. ./devtools/ndsdev/ndsdevctl stop
~~~

Stop, the start the container:
~~~
. ./devtools/ndsdev/ndsdevctl restart
~~~

## Tips and Tricks
Leave container running, but temporarily exit its shell:
~~~
CTRL+P, CTRL+Q, CTRL+C
~~~

Leave and stop the container:
~~~
exit
~~~
