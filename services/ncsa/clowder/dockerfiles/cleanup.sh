#!/bin/bash

# remove backup files
find . -name \*~ -delete -print

# intermediate and stopped images
docker rm $(docker ps -a -q -f 'status=exited')
docker rmi $(docker images | grep '^<none>' | awk '{print $3}')

# pecan
#docker rmi $(docker images | grep '^pecan/' |  awk '{print $1":"$2}')

# polyglot
docker rmi $(docker images | grep '^pecan/polyglot' |  awk '{print $1":"$2}')
docker rmi $(docker images | grep '^polyglot/' |  awk '{print $1":"$2}')
docker rmi $(docker images | grep '^ncsa/browndog-pecan' | awk '{print $1":"$2}')
docker rmi $(docker images | grep '^ncsa/browndog-polyglot' | awk '{print $1":"$2}')

# clowder

