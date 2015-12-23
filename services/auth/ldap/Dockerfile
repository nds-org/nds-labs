FROM fedora
MAINTAINER raila@illinois.edu
#
# 	A Simple LDAP server with web admin interface, data in data container,
# 	and optional env args for domain passwd and orgnanization
#
# Build:
# 	docker build -t ndsldap .
#
# Usage:
# 1. Create an LDAP data container
#	docker run --name=ldap-data -v /var/lib/ldap -v /etc/ldap/slapd.d scratch /bin/true
# 2. Run the image, mapping volumes from the data container
# docker run -d --volumes-from ldap-data -p 389:389 -p 80:80
# optional-args
#   -e LDAP_DOMAIN=example.com \
#   -e LDAP_ADMIN_PWD=toor \
#   -e LDAP_ORGANIZATION=docker.io Example Inc. \
#   /ldap
# 

RUN dnf -y update \
	&& dnf install -y nginx \
		php-fpm \
		openldap \
		openldap-servers \
		openldap-clients \
		phpldapadmin \
	&&  dnf clean all

RUN mkdir /opt/slapd
ADD service/slapd/slapd.sh /opt/slapd/slapd.sh
ADD service/slapd/setup.sh /opt/slapd/setup.sh

RUN mkdir /opt/phpldapadmin
ADD service/phpldapadmin/ldapadmin.sh /opt/phpldapadmin/ldapadmin.sh
ADD service/start.sh /opt/start.sh
ADD service/systemd-to-init.py /opt/systemd-to-init.py


#
## Convert service systemd scripts to init
#
RUN /opt/systemd-to-init.py /usr/lib/systemd/system/php-fpm.service > /etc/init.d/php5-fpm
RUN /opt/systemd-to-init.py /usr/lib/systemd/system/nginx.service > /etc/init.d/nginx
RUN chmod 755 /etc/init.d/*

ADD service/nginx/phpldapadmin.nginx /etc/nginx/sites-available/phpldapadmin

ENV LDAP_DOMAIN labs.nds.org
ENV LDAP_ADMIN_PWD gro.sdn.sbal
ENV LDAP_ORGANIZATION NDS Labs www.nds.org

EXPOSE 80
EXPOSE 389

VOLUME /var/lib/ldap
VOLUME /etc/ldap/slapd.d

CMD ["/opt/start.sh"]
