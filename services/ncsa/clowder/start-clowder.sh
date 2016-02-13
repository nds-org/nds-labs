#!/bin/bash

# Create required services first
# This will inject environment variables for each into any pods started after the service
kubectl create -f services/clowder-service.yaml
kubectl create -f services/mongo-service.yaml

# Now create our first phase of replication controllers (which will create some pods)
kubectl create -f controllers/mongo-controller.yaml

REQ_ES="elasticsearch"
REQ_RABBITMQ=(plantcv image-preview video-preview)
OPTIONAL_PLUGINS=(plantcv image-preview video-preview elasticsearch)

# Check for optional plugin with no dependencies (elasticsearch)
if [[ "${@/#$REQ_ES/ }" != "$@" ]] ; then
	echo "Starting elasticsearch..."
	kubectl create -f services/elasticsearch-service.yaml
fi

# Check for optional plugins that would require RabbitMQ (extractors: image-preview, video-preview, plantcv, etc) 
for i in "${REQ_RABBITMQ[@]}"; do
	if [[ "$RABBIT_ENABLED" != "true" && ( "${@/#$i/ }" != "$@" ) ]]; then
		echo "Extractors require RabbitMQ... Starting RabbitMQ..."
		kubectl create -f services/rabbitmq-service.yaml
		kubectl create -f controllers/rabbitmq-controller.yaml
		echo "Waiting for RabbitMQ to be ready..."

		# TODO: Need a better way to wait for RabbitMQ to come up
		# netcat? create a simple 'kubectl wait' script?
		sleep 45s
		break
	fi
done

# Now enable the requested optional controllers
for i in "$@"; do
	if [[ ( "${@/#$i/ }" != "$@" ) ]]; then
		echo "Starting $i..."
		kubectl create -f controllers/$i-controller.yaml
	else
		echo "Skipping unrecognized plugin: $i"
	fi
done

# Now start clowder itself
echo "Starting Clowder..."
kubectl create -f controllers/clowder-controller.yaml
