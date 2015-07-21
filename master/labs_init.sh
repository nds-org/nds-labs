#!/bin/bash

# Setup remote access

# We have to copy it like this since just mapping the file
# will leave the ownership and permissions bits wrong
cp /root/.ssh/authorized_keys_on_host /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Clone (or update) repository

if [ -z "$NDSLABS_BRANCH" ]; then
  NDSLABS_BRANCH=default
fi

if [ -d /root/nds-labs ]; then
  # updating existing working copy
  pushd /root/nds-labs &>/dev/null
  hg pull
  hg update --clean $NDSLABS_BRANCH
  popd &>/dev/null
else
  # download new working copy
  hg clone https://bitbucket.org/nds-org/nds-labs /root/nds-labs
  pushd /root/nds-labs &>/dev/null
  hg update --clean $NDSLABS_BRANCH
  popd &>/dev/null
fi

# Start services

cd /root/nds-labs/servicefiles

fleetctl start proxy.service
fleetctl start rabbitmq-server.service
#fleetctl start docker-registry.service

# Start listening for incoming SSH connections

# -D option is "do not detach"
exec /usr/sbin/sshd -D

