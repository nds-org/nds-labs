FROM rocker/rstudio
 
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

RUN pip install sympy
RUN pip install --allow-external pattern

# install irods client
ADD irods-fuse.sh /tmp/irods-fuse.sh
RUN bash /tmp/irods-fuse.sh

ADD ./setup_irods.py /usr/local/bin/setup_irodsuser
RUN chmod +x /usr/local/bin/setup_irodsuser

RUN mkdir /mnt/data && chown docker:root /mnt/data
RUN mkdir /results && chown docker:root /results
