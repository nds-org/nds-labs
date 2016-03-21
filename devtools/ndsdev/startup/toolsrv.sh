#!/bin/sh

docker run -d -p 8082:8082 --name toolserver -v /var/run/docker.sock:/var/run/docker.sock ndslabs/toolserver:terra toolserver
