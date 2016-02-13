IMAGES	= clowder image-preview video-preview plantcv
ORG 	= NDS
VERSION = 1.0
# include $(NDSLABS_SRC)/devtools/Makefiles/Makefile.nds

all-from-src:
	make clowder-from-src
	make image-preview-from-src
	make video-preview-from-src
	make plantcv-from-src

all:
	make clowder
	make image-preview
	make video-preview
	make plantcv 

clean:
	make clean-src
	docker rmi ncsa/clowder-python-base:latest
	docker rmi ndslabs/image-preview:latest
	docker rmi ndslabs/video-preview:latest
	docker rmi ndslabs/plantcv:latest
	docker rmi ndslabs/clowder:latest

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
	docker build -t ncsa/clowder-python-base:latest dockerfiles/clowder/python-base

clowder-from-src:
	docker build -t ndslabs/clowder:latest dockerfiles/clowder/clowder

image-preview-from-src:
	docker build -t ndslabs/image-preview:latest dockerfiles/clowder/image-preview

video-preview-from-src:
	docker build -t ndslabs/video-preview:latest dockerfiles/clowder/video-preview

plantcv-from-src:
	docker build -t ndslabs/plantcv:latest dockerfiles/clowder/plantcv
