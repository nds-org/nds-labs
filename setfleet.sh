
# source this before issuing fleetctl commands remotely
#   (from machines other than a coreos machine that is a 
#    member of the fleet/etcd cluster)

# ssh keys need to be set from _this_ machine to the 
# TUNNEL machine as well

# Also, depending on the operating system of _this_ machine,
# the fleetctl binary may need to be copied from the coreos
# system to _this_ system

# Also, depending, you may need to start a local ssh-agent
#   eval $(ssh-agent -s)
#   ssh-add 

export FLEETCTL_TUNNEL=141.142.204.184
export FLEETCTL_SSH_USERNAME=core

