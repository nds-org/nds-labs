FROM rocker/rstudio
 
ENV DEBIAN_FRONTEND noninteractive
ENV IRODS_DATADIR /tempZone/home/rods/data

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qyy \
    	fuse libfuse-dev git-core ca-certificates libssl-dev \
	apache2 libapache2-mod-proxy-html libxml2-dev && \ 
    apt-get clean

# install irods client
ADD irods-fuse.sh /tmp/irods-fuse.sh
RUN bash /tmp/irods-fuse.sh

ADD ./setup_irods.py /usr/local/bin/setup_irodsuser
ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN chmod +x /usr/local/bin/setup_irodsuser
ADD irods_setup.conf /etc/supervisor/conf.d/irods_setup.conf

RUN a2enmod proxy && a2enmod proxy_http

RUN mkdir /mnt/data && chown docker:root /mnt/data
RUN mkdir /results && chown docker:root /results
