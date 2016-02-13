HUBIMAGES=clowder image-preview video-preview plantcv
IMAGES=$(HUBIMAGES) 
ORG 	= NDS
VERSION = 1.0
include ../../../../devtools/Makefiles/Makefile.nds

all-from-src:
	make python-base-from-src
	make clowder-from-src
	make image-preview-from-src
	make video-preview-from-src
	make plantcv-from-src

#all:
#	make clowder
#	make image-preview
#	make video-preview
#	make plantcv 

clean:
#	make clean-src
	docker rmi ncsa/clowder-python-base:latest
	docker rmi ndslabs/image-preview:latest
	docker rmi ndslabs/video-preview:latest
	docker rmi ndslabs/plantcv:latest
	docker rmi ndslabs/clowder:latest

#image-preview:
#	docker pull ndslabs/image-preview:latest

#video-preview:
#	docker pull ndslabs/video-preview:latest

#plantcv:
#	docker pull ndslabs/plantcv:latest

#clowder:
#	docker pull ndslabs/clowder:latest

#git-src:
#	git clone https://opensource.ncsa.illinois.edu/bitbucket/scm/bd/dockerfiles.git

#clean-src:
#	rm -rf dockerfiles/

python-base-from-src:
	docker build -t ncsa/clowder-python-base:latest -f Dockerfile.python-base .

clowder-from-src:
	docker build -t ndslabs/clowder:latest -f Dockerfile.clowder .

image-preview-from-src:
	docker build -t ndslabs/image-preview:latest -f Dockerfile.image-preview .

video-preview-from-src:
	docker build -t ndslabs/video-preview:latest -f Dockerfile.video-preview .

plantcv-from-src:
	docker build -t ndslabs/plantcv:latest -f Dockerfile.plantcv .
