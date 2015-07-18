#!/bin/bash

mkdir -p /var/repo/
mkdir -p /var/tmp/phd/pid

sed -e '/^;date.timezone/ s/;\(.*\)$/\1 "UTC"/' \
   -i /etc/php5/apache2/php.ini
sed -e "s/__HOSTNAME__/${PHAB_HOSTNAME}" \
   -i /etc/apache2/sites-available/000-default.conf

service mysql start

cd /srv/phabricator
chown www-data -R *
./bin/storage upgrade --force
./bin/config set phabricator.base-uri "http://${PHAB_HOSTNAME}/"
#  AFTER mysql
mysql -e "REPAIR TABLE phabricator_search.search_documentfield;"
service mysql stop

sleep 1
supervisorctl start mysql
supervisorctl start apache2
sleep 2
supervisorctl start PhabricatorRepositoryPullLocalDaemon
supervisorctl start PhabricatorGarbageCollectorDaemon
supervisorctl start PhabricatorTaskmasterDaemon1
supervisorctl start PhabricatorTaskmasterDaemon2
supervisorctl start PhabricatorTaskmasterDaemon3
supervisorctl start PhabricatorTaskmasterDaemon4
