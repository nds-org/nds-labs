import os
import requests
from string import Template
from novaclient.v1_1 import client

CLOUD_CONFIG = Template('''#cloud-config

coreos:
  etcd:
    # generate a new token for each unique cluster from https://discovery.etcd.io/new
    discovery: $etcd
    # multi-region and multi-cloud deployments need to use $$public_ipv4
    addr: $$private_ipv4:4001
    peer-addr: $$private_ipv4:7001
  units:
    - name: etcd.service
      command: start
    - name: fleet.service
      command: start
ssh_authorized_keys:
  # include one or more SSH public keys
  - $sshkey
''')


SSHKEY = os.environ.get('SSHKEY', '/home/kacperk/shakuras.pub')
USER = os.environ.get('OS_USERNAME', 'NCSAUSER')
PASS = os.environ.get('OS_PASSWORD', 'NCSAPASS')
TENANT = os.environ.get('OS_TENANT_NAME', 'NCSATENANT')
AUTH_URL = os.environ.get('OS_AUTH_URL', 'NCSAURL')

with open(SSHKEY, 'r') as fh:
    sshkey = fh.read()

nt = client.Client(USER, PASS, TENANT, AUTH_URL, service_type="compute")
freeips = [ip for ip in nt.floating_ips.list() if ip.fixed_ip is None]

if len(freeips) < 1:
    exit("No free floating ips")

with open('cloud-config.yaml', 'w') as fh:
    etcd_token = requests.get("https://discovery.etcd.io/new").text
    fh.write(CLOUD_CONFIG.substitute(etcd=str(etcd_token),
                                     sshkey="%s" % sshkey))
instance = nt.servers.create(
    "coreos_%s" % USER, 
    "fd4d996e-9cf4-42bc-a834-741627b0e499", 3,
    min_count=3, max_count=3,
    security_groups=["default", "coreos"], 
    userdata="cloud-config.yaml", key_name="shakuras",
    nics=[{"net-id": "165265ee-d257-43d7-b3b7-e579cd749ed4"}]
)
instance.add_floating_ip(freeips[0])
