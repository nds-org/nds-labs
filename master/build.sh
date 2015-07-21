#!/bin/bash

# We have to do this because docker won't 
# let us use ADD ../foo in the Dockerfile

cp /usr/bin/fleetctl .

docker build -t ndslabs/master .

rm fleetctl

