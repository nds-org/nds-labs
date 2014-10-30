# See https://coreos.com/docs/running-coreos/platforms/openstack/

nova boot \
--user-data ./coreos-config.yaml \
--image 85d57540-448c-4256-9d85-5147723d95f7 \
--key-name core \
--flavor m1.medium \
--num-instances 3 \
--security-groups default coreos \
--config-drive=true \
--nic net-id=165265ee-d257-43d7-b3b7-e579cd749ed4
