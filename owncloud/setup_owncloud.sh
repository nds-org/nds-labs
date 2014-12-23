#!/bin/bash

cat >> /var/www/owncloud/config/autoconfig.php << EOF
<?php
\$AUTOCONFIG = array (
  'directory' => '/var/www/owncloud/data',
  'dbtype' => 'pgsql',
  'dbname' => 'owncloud',
  'dbhost' => 'db2',
  'dbtableprefix' => 'oc_',
  'dbuser' => 'ocadmin',
  'dbpass' => '${owncloudpassword}',
  'installed' => false,
);
EOF

cat >> /var/www/owncloud/config/nds.config.php << EOF
<?php
\$CONFIG = array (
  'overwritewebroot' => '/owncloud',
);
EOF

/sbin/my_init
