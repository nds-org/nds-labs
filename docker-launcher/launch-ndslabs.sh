irodszone=tempZone
ytfidopassword=3nthr0py
IRODS_DATADIR=/${irodszone}/home/rods/data

#echo "Launching kallithea"
#source launch-kallithea.sh
echo "Launching postgres-icat"
source launch-postgres-icat.sh
echo "Launching ytwebapp"
source launch-ytwebapp.sh
echo "Waiting ..."
sleep 20
echo "Launching iRODS"
source launch-irods-icat.sh
