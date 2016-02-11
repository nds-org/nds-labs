IMAGES	=  terratoolsrv
VERSION = 1.0
include ../../../devtools/Makefiles/Makefile.nds


testsrv:
	docker run --rm -it -p ${TOOLSRV_PORT}:8080 -v /var/run/docker.sock:/var/run/docker.sock terratoolsrv /usr/local/bin/terratoolsrv

testcli:
	curl -H "Content-Type: application/json" -X POST -d '{"host":"http://${TOOLSRV_ADDR}","dataset":"http://${CLOWDER_ADDR}:${CLOWDER_PORT}/api/datasets/${TOOLSRV_TARGET_DATASET}/download?key=${CLOWDER_KEY"}' ${TOOLSRV_ADDR}:${TOOLSRV_PORT}/tools/docker/ipython

testxfer:
	FILES.terratoolsrv/usr/local/bin/clowder-xfer 'http://${CLOWDER_ADDR}:${CLOWDER_PORT}/api/datasets/${TOOLSRV_TARGET_DATASET}/download?key=${CLOWDER_KEY}' /tmp/xfer.zip

testlog:
	curl -H "Content-Type: application/json" -X GET ${TOOLSRV_ADDR}:${TOOLSRV_PORT}/logs
