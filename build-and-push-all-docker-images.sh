#!/bin/bash

# Note that pushing requires a prior invocation of "docker login"

SCRIPTNAME=$(basename $0)

echo "Launching everything..."

while read SERVICENAME
do
  # subshell in background
  (
    echo "Processing $SERVICENAME..."

    # LOCALOUT is local to subshell
    LOCALOUT=$(mktemp -t $SCRIPTNAME.XXXXXXXX)

    # build docker image

    pushd ./$SERVICENAME &>/dev/null
    ./build.sh &>$LOCALOUT
    RC=$?
    popd &>/dev/null

    if [ $RC -eq 0 ]; then

      # push image to docker respository

      docker push ndslabs/$SERVICENAME &>$LOCALOUT
      RC=$?

      if [ $RC -eq 0 ]; then
        # all is good
        rm $LOCALOUT
        exit 
      fi

    fi

    # only got here if error occurred

    # send messages to stdout
    cat $LOCALOUT
    rm $LOCALOUT

  ) &

done <<EOF
curldrop
hublaunch
irods-icat
irods-idrop2
irods-rest
kallithea
moinmoin
nginx
owncloud
postgres-icat
postgres-owncloud
proxy
rabbitmq-server
rstudio
EOF

# a short sleep to wait for child processes to issue first message
sleep 2

echo "Everything is launched"
echo "Waiting for all processing to complete"
wait
echo "All processing is complete"

