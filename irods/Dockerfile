FROM ubuntu:14.04
MAINTAINER matthewturk@gmail.com
VOLUME ["/var/lib/irods/Vault", "/mnt/data"]
ENV irodszone tempZone
ENV localzonesid TEMP_LOCAL_ZONE_SID
ENV keyforagent temp_32_byte_key_for_agent__conn
ENV dbhost db1
ENV irodspassword testpassword
ENV ytfidopassword 3nthr0py


RUN apt-get update
RUN apt-get upgrade -y

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server supervisor wget dpkg sudo libcurl4-gnutls-dev

RUN mkdir -p /var/run/sshd

#set up supervisor
RUN mkdir -p /var/log/supervisor
ADD ./common/supervisord.conf.etc /etc/supervisor/supervisord.conf
ADD ./common/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# set up an admin user
RUN useradd admin
RUN echo 'admin:admin' | chpasswd
RUN mkdir /home/admin
RUN chown admin:admin /home/admin
RUN chsh -s /bin/bash admin

#install iRODS
RUN wget -P /home/admin ftp://ftp.renci.org/pub/irods/releases/4.0.3/irods-database-plugin-postgres-1.3.deb
RUN wget -P /home/admin ftp://ftp.renci.org/pub/irods/releases/4.0.3/irods-icat-4.0.3-64bit.deb
RUN wget -P /home/admin ftp://ftp.renci.org/pub/irods/plugins/irods_microservice_plugins_curl/1.1/irods-microservice-plugins-curl-1.1.deb

# install package dependencies to prevent Docker build from erring out
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y `dpkg -I /home/admin/irods-icat-4.0.3-64bit.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
RUN dpkg -i /home/admin/irods-icat-4.0.3-64bit.deb

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y `dpkg -I /home/admin/irods-database-plugin-postgres-1.3.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
RUN dpkg -i /home/admin/irods-database-plugin-postgres-1.3.deb

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y `dpkg -I /home/admin/irods-microservice-plugins-curl-1.1.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
RUN dpkg -i /home/admin/irods-microservice-plugins-curl-1.1.deb

ADD ./icat/server.sh /home/admin/server.sh
ADD ./icat/runAll.sh /home/admin/runAll.sh
ADD ./icat/setup-irods-docker.sh /home/admin/setup-irods-docker.sh
RUN chmod a+x /home/admin/runAll.sh

# irods needs to be part of admin to execute supervisorctl
EXPOSE 22 1247
ENTRYPOINT /home/admin/setup-irods-docker.sh
