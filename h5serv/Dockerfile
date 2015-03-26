FROM debian:sid

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qqy update && apt-get install -qqy wget \
     python-dev python-pip git libssl-dev supervisor \
     python-setuptools python-numpy python-tz \
     python-h5py python-requests python-twisted python-tornado && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# add a user
RUN useradd -D --shell=/bin/bash && \
    useradd -m user && \
    echo "user:secret" | chpasswd

# git h5serve source tree
RUN cd /home/user && \
   git clone https://github.com/HDFGroup/h5serv.git h5serv && \
   chown user:user -R /home/user

ADD ./supervisord.conf /etc/supervisord.conf
ADD ./main.conf /etc/supervisor/conf.d/main.conf

EXPOSE 5000

CMD supervisord -n -c /etc/supervisord.conf
