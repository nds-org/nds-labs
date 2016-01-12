IMAGES	= pysherpactl scratch sherpa apiserv
ORG 	= NDS
VERSION = 1.0

#
# Build the sherpa binary in $(DEPS)
# dev image builds the binary and installs in /build
# 
FILES.pysherpactl := pysherpactl-usage pysherpactl
GIT.apiserv := https://github.com/hfaran/Tornado-JSON.git

include $(NDSLABS_SRC)/devtools/Makefiles/Makefile.nds

testapi:
	docker run --rm -it apiserv bash -p 8080:8080
