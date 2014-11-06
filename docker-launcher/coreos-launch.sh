# See https://coreos.com/docs/running-coreos/platforms/openstack/

nova boot \
--user-data ./coreos-config.yaml \
--image 3a03810f-2ede-4f9e-8766-3b574388b2df \
--key-name bb \
--flavor 3 \
--num-instances 3 \
--security-groups default coreos \
--config-drive=true \
--nic net-id=165265ee-d257-43d7-b3b7-e579cd749ed4
