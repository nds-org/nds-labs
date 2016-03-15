#!/bin/bash

# If "-m" is specified, keep mongo running
if [[ "${@/#-m/ }" != "$@" ]]; then
# 	kubectl delete -f controllers/tool-mgr-controller.yaml
	kubectl delete -f controllers/clowder-controller.yaml
	kubectl delete -f controllers/plantcv-controller.yaml
	kubectl delete -f controllers/image-preview-controller.yaml
	kubectl delete -f controllers/video-preview-controller.yaml
	kubectl delete -f controllers/rabbitmq-controller.yaml
	kubectl delete -f controllers/elasticsearch-controller.yaml

#	kubectl delete -f services/tool-mgr-service.yaml
	kubectl delete -f services/clowder-service.yaml
	kubectl delete -f services/rabbitmq-service.yaml 
	kubectl delete -f services/elasticsearch-service.yaml
else
	# Kill off the controllers first (this brings down the pods)
	kubectl delete -f controllers/

	# Now that the pods are down, we can safely bring down the services
	kubectl delete -f services/
fi
