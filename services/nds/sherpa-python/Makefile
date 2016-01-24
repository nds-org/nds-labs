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
	docker run --rm -it -p 8080:8080 apiserv sh 

testcli:
	curl -H "Content-Type: application/json" -X POST -d '{"host":"http://localhost","dataset":"http://localhost/something","user":"raila@illinois.edu","pw":"passcred"}' localhost:8080/tools/docker/ipython
	#curl http://localhost:8080/tools/docker/ipython -d "dataset=http://localhost/something" -d "user=raila@illinois.edu" -d "pw=passtext" -X POST -v
