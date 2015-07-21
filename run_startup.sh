#!/bin/bash

# deal with VLAD networking
# iptables -A OUTPUT -t nat -p tcp -d 10.10.236.1 -j DNAT --to 127.0.0.1
# ssh -L localhost:5000:localhost:5000 -L localhost:8774:localhost:8774 -4 -nNT vlad-mgmt

# image-id coreos 681  a8839020-cb32-46c7-b0d4-882c5315dc22
# net-id nds_net       165265ee-d257-43d7-b3b7-e579cd749ed4
# flavor-id s1.medium  02a02a3c-d0b4-4bd1-9933-bb4391ad10b2

# ssh-key-name is the name (as known by OpenStack) of the key that was added to OpenStack

source NDS-openrc.sh

python startup_ndslabs.py \
 --dbvol-id ac747c89-4e9c-46e1-8c10-e95af4b49d51 \
 --icatvol-id d8bdc318-789c-463e-83f9-811e97c615c3 \
 --moinmoin-id 51ce47c2-9920-4964-83e1-b5427ae4f96e \
 --ip 141.142.204.184 \
 --total-vms 3 \
 --total-public 1 \
 --name mfreemon \
 --ssh-key $PWD/ssh-key.pub \
 --env-file $PWD/docker-launcher/production.env \
 --region NCSA \
 --net-id 165265ee-d257-43d7-b3b7-e579cd749ed4 \
 --image-id a8839020-cb32-46c7-b0d4-882c5315dc22 \
 --flavor-id 02a02a3c-d0b4-4bd1-9933-bb4391ad10b2

