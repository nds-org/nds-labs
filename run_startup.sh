#!/bin/bash

# --ip            The desired IP address (optional)
# --total-vms     The total number of OpenStack instances to be created
# --total-public  The number of OpenStack instances that should have a 
#                 public IP address associated with it
# --name          Used to construct easily identifable name for the
#                 OpenStack instances and key pairs
# --ssh-key       The public key that will be granted access to the
#                 OpenStack instances and NDS Services
# --env-file      A file that contains various environment variables

source NDS-openrc.sh

python startup_ndslabs.py \
 --total-vms 3 \
 --total-public 1 \
 --name mfreemon \
 --ssh-key $PWD/ssh-key.pub \
 --env-file $PWD/docker-launcher/production.env 

# specifying an IP address is optional, but if desired, the format is:
# --ip 141.142.204.184 \

