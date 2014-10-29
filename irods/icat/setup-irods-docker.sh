#!/bin/bash

cat <<EOF > /home/admin/dbresp
irods
irods
${irodszone}
1247
20000
20199
/var/lib/irods/Vault
${localzonesid}
${keyforagent}
rods
rods
yes
${dbhost}
5432
ICAT
irods
${irodspassword}

EOF

sudo su -c "/var/lib/irods/packaging/setup_irods.sh </home/admin/dbresp"
sudo usermod -G admin -a irods
#change irods user's irodsEnv file to point to localhost, since it was configured with a transient Docker container's hostname
sed -i 's/^irodsHost.*/irodsHost localhost/' /var/lib/irods/.irods/.irodsEnv
/usr/bin/supervisord "-n"
