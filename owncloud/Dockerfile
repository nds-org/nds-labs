FROM btobolaski/owncloud
MAINTAINER Matthew Turk "matthewturk@gmail.com"
RUN apt-get -y update
RUN apt-cache search php5
RUN cat /etc/lsb-release
RUN apt-get install -y apache2 php5-pgsql php5-ldap 
