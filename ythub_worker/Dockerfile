# Sets up a container for the web based lab login
#
# VERSION               0.0.1

# At some point, more of this will be pushed into its own docker image

#FROM      phusion/baseimage:0.9.13

FROM debian:sid
MAINTAINER Kacper Kowalik "xarthius.kk@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && \
    apt-get install -qy curl sudo python-dev python-pip git-core docker.io libfuse-dev libssl-dev && \
    apt-get clean


# add a user
RUN useradd -D --shell=/bin/bash && \
    useradd -m user && \
    echo "user:secret" | chpasswd && \
    adduser user sudo && \
    gpasswd -a user docker && \
    sudo -u user mkdir /home/user/yt_serve

# install irods client
ADD irods-fuse.sh /tmp/irods-fuse.sh
RUN bash /tmp/irods-fuse.sh

# supervisor process manager
RUN pip install supervisor
ADD aux/supervisor/supervisord.conf /etc/supervisord.conf

RUN curl -O https://bitbucket.org/nds-org/yt_webapp/raw/master/rest2/requirements.txt && \ 
    pip install -r requirements.txt && rm -rf requirements.txt

ADD aux/supervisor/yt_worker.conf /etc/supervisor.d/yt_worker.conf
ADD aux/supervisor/yt_serve.conf /etc/supervisor.d/yt_serve.conf
ADD aux/supervisor/docker.conf /etc/supervisor.d/docker.conf
ADD aux/app/ /home/user/yt_serve/

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

VOLUME /var/lib/docker
CMD /bin/bash
CMD supervisord -n -c /etc/supervisord.conf
