#!/bin/bash
set -e

# some helper functions
BASEDIR=./clowder
CLOWDERDIR=$BASEDIR/clowder
CUSTOMDIR=$CLOWDERDIR/custom

# add/replace plugin if variable is non empty
# $1 = variable to check if defined
# $2 = index of plugin
# $3 = plugin class
function fix_plugin() {
    if [ "$2" == "" ]; then return 0; fi
    if [ "$3" == "" ]; then return 0; fi

    if [ -e $CUSTOMDIR/play.plugins ]; then
        mv $CUSTOMDIR/play.plugins $CUSTOMDIR/play.plugins.old
        grep -v ":$2" $CUSTOMDIR/play.plugins.old > $CUSTOMDIR/play.plugins
        rm $CUSTOMDIR/play.plugins.old
    fi
    if [ "$1" != "" ]; then
        echo "Writing $2:$3..."
        echo "$2:$3" >> $CUSTOMDIR/play.plugins
    fi
}

# add/replace if variable is non empty
# $1 = variable to replace/remove
# $2 = new value to set
# $3 = additional variable to remove
function fix_conf() {
    echo "Writing $2 => $1"
    if [ "$3" != "" ]; then
	echo "Removing old value: $3"
    fi
    local query
    if [ "$1" == "" ]; then return 0; fi

    if [ -e $CUSTOMEDIR/custom.conf ]; then
        if [ "$3" == "" ]; then
            query="$1"
        else
            query="$1|$3"
        fi

        mv $CUSTOMDIR/custom.conf $CUSTOMDIR/custom.conf.old
        grep -v "^(${query})=" $CUSTOMDIR/custom.conf.old > $CUSTOMDIR/custom.conf
        rm $CUSTOMDIR/custom.conf.old
    fi

    if [ "$2" != "" ]; then
        echo "$1=\"$2\"" >> $CUSTOMDIR/custom.conf
    fi
}

# start server if asked
if [ "$1" = '-o' ]; then
    # rabbitmq
    fix_plugin "$ENABLE_RABBITMQ" "9992" "services.RabbitmqPlugin"
    fix_conf   "clowder.rabbitmq.uri" "$RABBITMQ_URI" "medici2.rabbitmq.uri"
    fix_conf   "clowder.rabbitmq.exchange" "$RABBITMQ_EXCHANGE" "medici2.rabbitmq.exchange"
    fix_conf   "clowder.rabbitmq.managmentPort" "$RABBITMQ_MGMT_PORT" "medici2.rabbitmq.managmentPort"

    # mongo
    fix_conf   "mongodbURI" "$MONGO_URI"

    # smtp
    fix_conf   "smtp.host" "$SMTP_HOST"

    # elasticsearch
    fix_plugin "$ENABLE_ELASTICSEARCH" "10700" "services.ElasticsearchPlugin"
    fix_conf   "elasticsearchSettings.clusterName" "$ELASTICSEARCH_CLUSTERNAME"
    fix_conf   "elasticsearchSettings.serverAddress" "$ELASTICSEARCH_SERVER"
    fix_conf   "elasticsearchSettings.serverPort" "$ELASTICSEARCH_PORT"

    # start clowder
   # /bin/rm -f $CLOWDERDIR/RUNNING_PID
   # exec $CLOWDERDIR/bin/clowder -DMONGOUPDATE=1 -DPOSTGRESUPDATE=1 -Dapplication.context=$CLOWDER_CONTEXT
else
    if [ "$1 || $ENABLE_ELASTICSEARCH" ]; then
	echo "Enabling ElasticSearch..."
    fi
    if [ "$2 || $ENABLE_RABBITMQ" != "" ]; then
	echo "Enabling RabbitMQ..."
    fi
fi

