#!/bin/bash
set -e

# rabbitmq
if [ "$RABBITMQ_URI" == "" ]; then
	if [ -n "$RABBITMQ_PORT_5672_TCP_PORT" ]; then
		RABBITMQ_URI="amqp://guest:guest@${RABBITMQ_PORT_5672_TCP_ADDR}:${RABBITMQ_PORT_5672_TCP_PORT}/${RABBITMQ_VHOST}"
	fi
fi
if [ "$RABBITMQ_MGMT_PORT" == "" ]; then
	if [ -n "$RABBITMQ_PORT_15672_TCP_PORT" ]; then
		RABBITMQ_MGMT_PORT="$RABBITMQ_PORT_15672_TCP_PORT"
	fi
fi

# start server if asked
if [ "$1" = 'extractor' ]; then
	cd /home/clowder/extractors-image/preview

	# config.py
	/bin/sed -i -e "s#rabbitmqURL\s*=.*#rabbitmqURL='${RABBITMQ_URI}'#" config.py
	if [ "$RABBITMQ_EXCHANGE" != "" ]; then
		/bin/sed -i -e "s#rabbitmqExchange\s*=.*#rabbitmqExchange='${RABBITMQ_EXCHANGE}'#" config.py
	fi
	if [ "$RABBITMQ_QUEUE" != "" ]; then
		/bin/sed -i -e "s#extractorName\s*=.*#extractorName='${RABBITMQ_QUEUE}'#" config.py
	fi

	# start extractor
	for i in `seq 1 10`; do
		if nc -z $RABBITMQ_PORT_5672_TCP_ADDR $RABBITMQ_PORT_5672_TCP_PORT ; then
			exec ./ncsa.image.preview.py
		fi
		sleep 1
	done
	echo "Could not connect to RabbitMQ"
	exit -1
fi

exec "$@"
