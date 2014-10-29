ICAT_IMAGE=matthewturk/irods-icat
ICAT_CPORT=1247
ICAT_CID=$(docker run --link db1:db1 -d -p $ICAT_CPORT $ICAT_IMAGE)
ICAT_PORT=$(docker port $ICAT_CID $ICAT_PORT | awk -F: '{ print $2 }')
