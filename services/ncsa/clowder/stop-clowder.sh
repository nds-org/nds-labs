#!/bin/bash

# Kill off the controllers first (this brings down the pods)
kubectl delete -f controllers/

# Now that the pods are down, we can safely bring down the services
kubectl delete -f services/
