#!/bin/bash

mkdir -p ~/bin
if [ ! -e ~/bin/apictl ]; then
	curl https://raw.githubusercontent.com/nds-org/nds-labs/v2/apictl/build/bin/amd64/apictl -o  ~/bin/apictl
	chmod +x ~/bin/apictl
fi

kubectl create -f ndslabs/gui.yaml
kubectl create -f ndslabs/apiserver.yaml
