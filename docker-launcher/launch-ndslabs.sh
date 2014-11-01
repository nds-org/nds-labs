RABBIT_IMAGE=ndslabs/rabbitmq-server:latest
CELERY_IMAGE=ndslabs/ythub_worker:latest
PGICAT_IMAGE=ndslabs/postgres-icat
ICAT_IMAGE=ndslabs/irods-icat

PGICAT_NAME=db1
ICAT_NAME=icat1
RABBIT_NAME=rabbit
ICAT_CPORT=1247
ICAT_RESOURCES=/mnt/data
irodszone=tempZone
ytfidopassword=3nthr0py
IRODS_DATADIR=/${irodszone}/home/rods/data

PGICAT_CID=$(docker run --name db1 -d $PGICAT_IMAGE)
RABBIT_CID=$(docker run -d --name $RABBIT_NAME $RABBIT_IMAGE)
echo "Waiting for postgres and rabbitmq to start... (5s)"
sleep 5

RABBIT_AUTH=$(docker logs ${RABBIT_CID} | awk '/curl/ {print $3}')
BROKER_URL=amqp://${RABBIT_AUTH}@amq:${AMQ_PORT_5672_TCP_PORT}
echo ${BROKER_URL}
ICAT_CID=$(docker run -d \
   --name ${ICAT_NAME} \
   --link db1:db1 \
   -v ${ICAT_RESOURCES}:/mnt/data \
   -p $ICAT_CPORT \
   $ICAT_IMAGE)

echo "Waiting for irods to start... (20s)"
sleep 20
CELERY_CID=$(docker run -d \
   -v /var/lib/docker:/var/lib/docker \
   --privileged -p 8888 \
   --link $RABBIT_NAME:amq \
   --link ${ICAT_NAME}:${ICAT_NAME} \
   -e BROKER_URL=${BROKER_URL} \
   -e ytfidopassword=${ytfidopassword} \
   -e ICAT_NAME=${ICAT_NAME} \
   -e ICAT_CPORT=${ICAT_CPORT} \
   -e irodszone=${irodszone} \
   -e IRODS_DATADIR=${IRODS_DATADIR} \
   ${CELERY_IMAGE})
