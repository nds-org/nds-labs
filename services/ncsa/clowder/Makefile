IMAGES	= clowderctl-dev clowderctl
ORG 	= NDS
VERSION = 1.0
# include $(NDSLABS_SRC)/devtools/Makefiles/Makefile.nds

all-from-src:
	make git-src
	make python-base-from-src
	make clowder-from-src
	make image-preview-from-src
	make video-preview-from-src
	make plantcv-from-src

all:
	make python-base
	make clowder
	make image-preview
	make video-preview
	make plantcv 

IMAGE.clowderctl: $(BUILDDIR)/clowderctl
#
# Build the clowder binary in $(DEPS)
# dev image builds the binary and installs in /build
# 
$(BUILDDIR)/clowderctl: IMAGE.clowderctl-dev
	docker run --rm -v `pwd`/$(DEPS):/build clowderctl-dev

livedev:
	docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`:/go/src/clowderctl clowderctl-dev bash

clean:
	make clean-src
	docker rmi clowder/python-base:latest
	docker rmi clowder/image-preview:latest
	docker rmi clowder/video-preview:latest
	docker rmi clowder/plantcv:latest
	docker rmi clowder/clowder:latest

python-base:
	docker pull ndslabs/python-base:latest

image-preview:
	docker pull ndslabs/image-preview:latest

video-preview:
	docker pull ndslabs/video-preview:latest

plantcv:
	docker pull ndslabs/plantcv:latest

clowder:
	docker pull ndslabs/clowder:latest

git-src:
	git clone https://opensource.ncsa.illinois.edu/bitbucket/scm/bd/dockerfiles.git

clean-src:
	rm -rf dockerfiles/

python-base-from-src:
	docker build -t clowder/python-base:latest dockerfiles/clowder/python-base

clowder-from-src:
	docker build -t clowder/clowder:latest dockerfiles/clowder/clowder

image-preview-from-src:
	docker build -t clowder/image-preview:latest dockerfiles/clowder/image-preview

video-preview-from-src:
	docker build -t clowder/video-preview:latest dockerfiles/clowder/video-preview

plantcv-from-src:
	docker build -t clowder/plantcv:latest dockerfiles/clowder/plantcv
