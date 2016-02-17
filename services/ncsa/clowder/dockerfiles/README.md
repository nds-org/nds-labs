# Dockerfiles for Clowder
This folder contains everything necessary to build up Clowder's docker images from the base Dockerfiles.

# Images Provided
* python-base
* image-preview
* video-preview
* plantcv
* clowder

# Prerequisites
You must be running a machine with **make** installed in order to utilize the Makefile present.

Fortunately, we provide a build image for just this purpose.

From the project root, run the following two commands to build and run an image with **make** included:
~~~
. ./devtools/ndsdev/ndsdevctl build
. ./devtools/ndsdev/ndsdevctl run
~~~

You should now be inside of the NDSDEV container:
~~~
Starting NDSDEV container...
[root@NDSDEV ] src # 
~~~

# Building the Images
Once you have acquired **make** or entered our NDSDEV container, simply run **make** from this folder
~~~
cd services/ncsa/clowder/dockerfiles/
make
~~~

You should then see the necessary images being built for you!

NOTE: plantcv can take upwards of ~25 minutes to fully build. Plan accodingly.
