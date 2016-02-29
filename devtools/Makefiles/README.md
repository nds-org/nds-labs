# NDS Make
Support for building container images in NDSLabs including support for multiple containers per source directory, intermediate build images (images with tools/etc. to build published images), and repository push.
##  Usage
  - make - build everything
  - make clean - clean all intermediate artifacts
  - make push - push all images to Docker repository
## User Make Variables and Examples
  - IMAGES - The names for the images to build
## Inherited, but overridable:
  - ORG - the Origanizational Name (default NDS)
## Naming Conventions
  - Dockerfile.<image> - the Dockerfile for a particular image
  - FILES.<image> - The file-tree of images that are added to an image at /
    - Can be assembled at build time
  - IMAGE.<name> -  a make target representing the built image
    - Useful for specifying ordering
## Example
This simple example shows a single-image example
  ### File structure:
```sh
├── Dockerfile.terratoolsrv
├── FILES.terratoolsrv
│   └── usr
│       └── local
│           └── bin
│               ├── clowder-xfer
│               ├── terratoolsrv
│               └── usage
├── Makefile
```
### Makefile
```sh
IMAGES  =  terratoolsrv
include ../../../devtools/Makefiles/Makefile.nds

# Tests
testsrv:
        docker run --rm -it -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock terratoolsrv /usr/local/bin/terratoolsrv

testlog:
        curl -H "Content-Type: application/json" -X GET localhost:8080/logs

```
### Dockerfile.terratoolsrv
```sh
FROM ubuntu
RUN apt-get -y update \
    && apt-get -y install curl unzip docker.io python python-dev python-pip \
    && pip install flask-restful \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    ;
COPY FILES.terratoolsrv /
CMD /usr/local/bin/usage
```
### Multi-Image and Dependencies
Useful when an intermediate build container with tooling is used to create the image to be published.
Simply specify dependencies to force ordering, and a rule to build:

```sh
IMAGES := builderimage productionimage
include ../../../devtools/Makefiles/Makefile.nds
# Production depends on builder - run builder to create production's file tree
$(IMAGE.productionimage): $(IMAGE.builderimage)
    docker run --rm -it $(IMAGE.builderimage) -v `pwd`/FILES.productionimage:/install install
    
```
### TODO
  * Add support for NDSLabs catalog spec files
    * Building?
    * Catalog push
  * Add support for changing docker hub
    * Currently just using docker push

