FROM fedora:21
MAINTAINER mfreemon@illinois.edu

# Install packages 
RUN yum -y update
RUN yum -y install openssh-server less vim-enhanced mercurial git docker-io

# Configure sshd
RUN mkdir -p /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

# Prep for ssh access
RUN mkdir /root/.ssh/
RUN chown root:root /root/.ssh/
RUN chmod 700 /root/.ssh

#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US.UTF-8
#ENV LC_ALL en_US.UTF-8

# fleetctl binary
ADD fleetctl /usr/bin/

# Labs initialization script
ADD labs_init.sh /root/

# SSH port
EXPOSE 22

WORKDIR /root/

# Default command to be executed 
# (can be overridden by the docker run command)
CMD ["/root/labs_init.sh"]

