#!/bin/bash

cd $EXTRACTOR_HOME
# If RabbitMQ URI is not set, use the default credentials; while doing so,
# handle the linking scenario, where RABBITMQ_PORT_5672 is set.
if [ "$RABBITMQ_URI" == "" ]; then
    if [ -n $RABBITMQ_PORT_5672 ]; then
        RABBITMQ_URI="amqp://guest:guest@${RABBITMQ_PORT_5672_TCP_ADDR}:${RABBITMQ_PORT_5672_TCP_PORT}/%2F"
    else
        RABBITMQ_URI="amqp://guest:guest@localhost:5672/%2F"
    fi
fi

# If a branch name is given, switch to it.
if [ -n "$EXTR_BRANCH" ]; then
    git fetch
    git checkout $EXTR_BRANCH
fi

# update extractor code everytime we build
git pull

# Set plantcv env var
/bin/sed -i -e "s#exRootPath =.*#exRootPath = '${CLOWDER_HOME}/extractors-plantcv'#" config.py
/bin/sed -i -e "s#plantcvOutputDir =.*#plantcvOutputDir = '${CLOWDER_HOME}/plantcv-output'#" config.py

# fix plancv bugs in analyze_color()
# analyze_color takes 11 args, but image_analysis scripts put 12
for d in nir_sv vis_sv  vis_tv
do
  for f in `ls ${CLOWDER_HOME}/plantcv/scripts/image_analysis/$d/*.py`
  do
    /bin/sed -i -e "s#'all','rgb'#'all'#" $f
  done
done

# start the extractor service
source ${CLOWDER_HOME}/pyenv/bin/activate && ./ex-plantcv.py
