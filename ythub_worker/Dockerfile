FROM debian:sid
MAINTAINER Kacper Kowalik "xarthius.kk@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV IRODS_DATADIR /tempZone/home/rods/data
RUN apt-get update -qq && \
    apt-get install -qy curl sudo python-dev python-pip git-core docker.io fuse libfuse-dev libssl-dev && \
    apt-get clean

# add a user
RUN useradd -D --shell=/bin/bash && \
    useradd -m user && \
    echo "user:secret" | chpasswd && \
    adduser user sudo && \
    gpasswd -a user docker && \
    sudo -u user mkdir /home/user/yt_serve && \
    echo "user_allow_other" >> /etc/fuse.conf

# install irods client
ADD irods-fuse.sh /tmp/irods-fuse.sh
RUN bash /tmp/irods-fuse.sh

# supervisor process manager
RUN pip install supervisor python-etcd
ADD aux/supervisor/supervisord.conf /etc/supervisord.conf

RUN curl -O https://bitbucket.org/nds-org/yt_webapp/raw/master/rest2/requirements.txt && \ 
    pip install -r requirements.txt && rm -rf requirements.txt

ADD aux/supervisor/yt_worker.conf /etc/supervisor.d/yt_worker.conf
ADD aux/supervisor/yt_serve.conf /etc/supervisor.d/yt_serve.conf
ADD aux/supervisor/ytfido_setup.conf /etc/supervisor.d/ytfido_setup.conf
ADD aux/supervisor/docker.conf /etc/supervisor.d/docker.conf
ADD aux/app/ /home/user/yt_serve/

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

ADD ./setup_irods.py /usr/local/bin/setup_irodsuser
RUN chmod +x /usr/local/bin/setup_irodsuser

VOLUME ["/tmp"]
CMD supervisord -n -c /etc/supervisord.conf
