IMAGES	=  terratoolsrv
VERSION = 1.0

#
# 
FILES.terratoolsrv := terratoolsrv-usage terratoolsrv

include ../../../devtools/Makefiles/Makefile.nds


testsrv:
	docker run --rm -it -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock terratoolsrv /usr/local/bin/terratoolsrv

testcli:
	curl -H "Content-Type: application/json" -X POST -d '{"host":"http://localhost","dataset":"http://141.142.21.5:9000/api/datasets/56981431bee8e09549b15a73/download","user":"raila@illinois.edu","pw":"clowder!ipython"}' localhost:8080/tools/docker/ipython

testlog:
	curl -H "Content-Type: application/json" -X GET localhost:8080/logs
