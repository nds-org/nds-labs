#!/bin/bash

rm -rf ipython-conf.tgz && tar cvzf ipython-conf.tgz ipython-conf

docker build -t ndslabs/hublaunch .

