import time
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
write_files:
  - path: /etc/fleet/fleet.conf
    content: |
      public_ip="$$private_ipv4"
      metadata="$ip_info"
''')


SSHKEY = os.environ.get('SSHKEY', '/home/kacperk/shakuras.pub')
KEYNAME = os.environ.get('SSHKEYNAME', 'shakuras')
USER = os.environ.get('OS_USERNAME', 'NCSAUSER')
PASS = os.environ.get('OS_PASSWORD', 'NCSAPASS')
TENANT = os.environ.get('OS_TENANT_NAME', 'NCSATENANT')
AUTH_URL = os.environ.get('OS_AUTH_URL', 'NCSAURL')
tot = 3
npublic = 1

with open(SSHKEY, 'r') as fh:
    sshkey = fh.read()

nt = client.Client(USER, PASS, TENANT, AUTH_URL, service_type="compute")
freeips = [ip for ip in nt.floating_ips.list() if ip.fixed_ip is None]
etcd_token = requests.get("https://discovery.etcd.io/new").text

if len(freeips) < 1:
    exit("No free floating ips")

for public, n in [(False, tot - npublic), (True, npublic)]:
    if public:
        ip_info = "elastic_ip=true,public_ip=$public_ipv4"
    else:
        ip_info = "elastic_ip=false"
    with open('cloud-config_%s.yaml' % public, 'w') as fh:
        etcd_token = etcd_token,
        fh.write(CLOUD_CONFIG.substitute(etcd=str(etcd_token),
                                        sshkey="%s" % sshkey,
                                        ip_info = ip_info))
    instance = nt.servers.create(
        "coreos_%s" % USER, 
        "fd4d996e-9cf4-42bc-a834-741627b0e499", 3,
        min_count=n, max_count=n,
        security_groups=["default", "coreos"], 
        userdata=open('cloud-config_%s.yaml' % public, 'r'), key_name=KEYNAME,
        nics=[{"net-id": "165265ee-d257-43d7-b3b7-e579cd749ed4"}]
    )
    time.sleep(10)
    if public:
        ip = freeips[0].ip
        instance.add_floating_ip(freeips[0])

print("export FLEETCTL_TUNNEL=%s:22" % ip)
