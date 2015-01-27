FROM ubuntu:trusty
MAINTAINER xarthisius.kk@gmail.com

VOLUME ["/mnt/uploads"]
EXPOSE 5000

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget python-tornado python-flask supervisor sudo unzip && \ 
    apt-get clean

RUN cd /tmp && wget https://github.com/Xarthisius/curldrop/archive/master.zip && \
    unzip master.zip

RUN sed -i /tmp/curldrop-master/config.py \
        -e "/BASEURL=/ s@'\(.*\)'@'http://labs.nationaldataservice.org/upload/'@" \
	-e "/^UPLOADDIR/ s@'\(.*\)'@'/mnt/uploads/'@"

CMD ["python", "/tmp/curldrop-master/runcurldrop.py"]

#set up supervisor
# RUN mkdir -p /var/log/supervisor
# ADD ./common/supervisord.conf.etc /etc/supervisor/supervisord.conf
# ADD ./common/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

