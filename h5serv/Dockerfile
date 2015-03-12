FROM ubuntu:14.04
MAINTAINER jkastner@ncsa.illinois.edu

ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update && apt-get install -y wget git

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install and setup minimal Anaconda Python dist
RUN wget http://repo.continuum.io/miniconda/Miniconda-3.9.1-Linux-x86_64.sh -O miniconda.sh
RUN bash miniconda.sh -b -p /anaconda && rm miniconda.sh
ENV PATH /anaconda/bin:$PATH

# For image inheritence
#ONBUILD ENV PATH /anaconda/bin:$PATH

# Install some h5serv dependencies
RUN conda create -n h5serv python=2.7 h5py twisted tornado requests pytz

# git h5serve source tree
RUN git clone https://github.com/HDFGroup/h5serv.git h5serv
RUN python /h5serv/server/app.py
RUN python /h5serv/test/testall.py
