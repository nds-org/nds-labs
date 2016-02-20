# FROM clowder/python-base
FROM ncsa/clowder-python-base:2.1
MAINTAINER Rob Kooper <kooper@illinois.edu>

USER root
RUN apt-get update && \
    apt-get install -y imagemagick && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV RABBITMQ_URI="" \
    RABBITMQ_EXCHANGE="clowder" \
    RABBITMQ_VHOST="%2F" \
    RABBITMQ_QUEUE="ncsa.video.preview"

USER clowder
RUN cd /home/clowder && \
    git clone https://opensource.ncsa.illinois.edu/stash/scm/cats/extractors-video.git

# command to run when starting docker
COPY FILES.video-preview/ /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["extractor"]
