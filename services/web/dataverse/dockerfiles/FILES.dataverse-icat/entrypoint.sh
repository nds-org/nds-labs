#!/bin/bash

set -e

if [ "$1" = 'icat' ]; then

	# generate configuration responses
	/opt/irods/genresp.sh /opt/irods/setup_responses

	if [ -n "$RODS_PASSWORD" ]; then 
    	sed -i "14s/.*/$RODS_PASSWORD/" /opt/irods/setup_responses
	fi

	if [ -n "$RODS_ZONE" ]; then
    	sed -i "3s/.*/$RODS_ZONE/" /opt/irods/setup_responses
	fi

	service postgresql start
	if [ !`sudo -u postgres psql -U postgres -d CCC -tAc "select count(*) from r_coll_main"` ]; then 

		# Only create the DB if it doesn't already exist
		/opt/irods/setupdb.sh /opt/irods/setup_responses
	fi

	# set up iRODS
	/opt/irods/config.sh /opt/irods/setup_responses

	sed -i 's/STAGING_RODS_ZONE/'"${STAGING_RODS_ZONE}"'/' /etc/irods/dvn_staging.r
	#change irods user's irodsEnv file to point to localhost

	# this script must end with a persistent foreground process
	sleep infinity

else
    exec "$@"
fi

