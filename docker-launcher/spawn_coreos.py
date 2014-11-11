import argparse
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
  fleet:
     metadata: $ip_info
ssh_authorized_keys:
  # include one or more SSH public keys
  - $sshkey''')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description = "Spawn our coreOS.")
    parser.add_argument('--ssh-key', action='store', dest='ssh_key',
                        default = "/home/mturk/core.pub")
    parser.add_argument('--ssh-key-name', action='store', dest='ssh_key_name',
                        default = 'core')
    parser.add_argument('--openstack-user', action='store',
                        dest='openstack_user',
                        default=os.environ.get('OS_USERNAME', None))
    parser.add_argument('--openstack-pass', action='store',
                        dest='openstack_pass',
                        default=os.environ.get('OS_PASSWORD', None))
    parser.add_argument('--openstack-url', action='store',
                        dest='openstack_url',
                        default=os.environ.get('OS_AUTH_URL', None))
    parser.add_argument('--openstack-tenant', action='store',
                        dest='openstack_tenant',
                        default=os.environ.get('OS_TENANT_NAME', None))
    parser.add_argument('--total-vms', action='store', type=int,
                        dest = 'total_vms', default=3)
    parser.add_argument('--total-public', action='store', type=int,
                        dest = 'total_public', default=1)
    parser.add_argument('--name', action='store', dest='cluster_name',
                        default='testing')
    parser.add_argument('--ip', action='store', dest='desired_ip',
                        default=None)
    parser.add_argument('--etcd-token', action='store', dest='etcd_token',
                        default=None)
    parser.add_argument('--region', action='store', dest='region',
                        default='NCSA')
    parser.add_argument('--net-id', action='store', dest='net_id',
                        default = '165265ee-d257-43d7-b3b7-e579cd749ed4')
    parser.add_argument('--vm-id', action='store', dest='vm_id',
                        default = 'fd4d996e-9cf4-42bc-a834-741627b0e499')
    args = parser.parse_args()

    with open(args.ssh_key, 'r') as fh:
        sshkey = fh.read()

    nt = client.Client(args.openstack_user, args.openstack_pass,
            args.openstack_tenant, args.openstack_url, service_type="compute")
    if args.etcd_token is None:
        args.etcd_token = requests.get("https://discovery.etcd.io/new").text

    for public, n in [
                      (True, args.total_public)
                      (False, args.total_vms - args.total_public),
                     ]:
	if n == 0: continue
        if public:
            ip_info = "elastic_ip=true,public_ip=$public_ipv4,region=$region"
        else:
            ip_info = "elastic_ip=false,region=$region"
        with open('cloud-config_%s.yaml' % public, 'w') as fh:
            fh.write(CLOUD_CONFIG.substitute(etcd=str(args.etcd_token),
                                            sshkey="%s" % sshkey,
                                            ip_info = ip_info,
                                            region = args.region))
        instance = nt.servers.create(
            "coreos_%s" % args.cluster_name,
            args.vm_id, 3,
            min_count=n, max_count=n,
            security_groups=["default", "coreos"],
            userdata=open('cloud-config_%s.yaml' % public, 'r'),
            key_name=args.ssh_key_name,
            nics=[{"net-id": args.net_id}]
        )
        if public:
            time.sleep(10)
            if args.desired_ip is None:
                freeips = [ip for ip in nt.floating_ips.list() if ip.fixed_ip is None]
            elif args.desired_ip.count('.') == 3:
                freeips = [ip for ip in nt.floating_ips.list() if 
                           ip.ip == args.desired_ip]
            else:
                freeips = [nt.floating_ips.get(args.desired_ip)]
            if len(freeips) < 1:
                exit("No free floating ips")
            ip = freeips[0].ip
            instance.add_floating_ip(freeips[0])
            print("export FLEETCTL_TUNNEL=%s" % ip)
    print ("ETCD_TOKEN=%s" % args.etcd_token)

