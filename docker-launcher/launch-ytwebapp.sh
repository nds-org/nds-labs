#!/bin/bash
RABBIT_HOST=rabbit
RABBIT_IMAGE=ndslabs/rabbitmq-server:latest
CELERY_IMAGE=ndslabs/ythub_worker:latest

RABBIT_CID=$(docker run -d --name $RABBIT_HOST $RABBIT_IMAGE)
RABBIT_AUTH=$(docker logs ${RABBIT_CID} | awk '/curl/ {print $3}')
BROKER_URL=amqp://${RABBIT_AUTH}@amq:${AMQ_PORT_5672_TCP_PORT}
CELERY_CID=$(docker run -d -v /var/lib/docker:/var/lib/docker --privileged -p 8888 --link $RABBIT_HOST:amq -e BROKER_URL=${BROKER_URL} ${CELERY_IMAGE})
