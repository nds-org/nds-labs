FROM debian:sid
 
ENV DEBIAN_FRONTEND noninteractive
ENV IRODS_DATADIR /tempZone/home/rods/data

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qyy \
      curl sudo python-dev python-pip git-core fuse libfuse-dev libssl-dev \
      build-essential liblapack-dev libatlas-dev gfortran libfreetype6 \
      libfreetype6-dev libpng12-dev python-lxml libyaml-dev g++ libffi-dev pkg-config \
      python-setuptools ipython-notebook python-scipy python-matplotlib \ 
      python-h5py cython python-hglib python-requests && \
    apt-get clean

# add a user
RUN useradd -D --shell=/bin/bash && \
    useradd -m user && \
    echo "user:secret" | chpasswd && \
    adduser user sudo && \
    echo "user_allow_other" >> /etc/fuse.conf

RUN pip install sympy
RUN pip install --allow-external pattern

# install irods client
ADD irods-fuse.sh /tmp/irods-fuse.sh
RUN bash /tmp/irods-fuse.sh

# Install yt
RUN cd /tmp && \
    hg clone -r stable http://bitbucket.org/yt_analysis/yt && \
    pushd yt &> /dev/null && \
    python2.7 setup.py install && \
    popd &> /dev/null \
    rm -rf yt

# ThingKing
RUN pip install thingking darksky_catalog

ADD ./setup_irods.py /usr/local/bin/setup_irodsuser
RUN chmod +x /usr/local/bin/setup_irodsuser

RUN mkdir /mnt/data && chown user:root /mnt/data

# IPython
ADD ./ipython-conf.tgz /home/user/
RUN chown -R user /home/user/
ENV IPYTHONDIR /home/user/ipython-conf

USER user
