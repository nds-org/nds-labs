#!/usr/bin/env python2

import os
import sys
import etcd
import subprocess
import urlparse
import json
from pwd import getpwnam

user = getpwnam("user")
uhome = user.pw_dir
uuid = user.pw_uid
ugid = user.pw_gid
ihome = os.path.join(uhome, ".irods")
if not os.path.isdir(ihome):
    os.mkdir(ihome, 0700)
    # os.chown(ihome, uuid, ugid)

if not os.path.isfile(os.path.join(ihome, ".irodsEnv")):
    host_ip = os.environ.get('COREOS_PRIVATE_IPV4', None)
    client = etcd.Client(host=host_ip, port=4001)
    with open(os.path.join(ihome, ".irodsEnv"), 'w') as fh:
        fh.write("irodsHost %s\n" % client.read('/irods/host').value)
        fh.write("irodsPort %s\n" % client.read('/irods/port').value)
        fh.write("irodsZone %s\n" % client.read('/irods/zone').value)
        fh.write("irodsUserName ytfido\n")
    # os.chown(os.path.join(ihome, ".irodsEnv"), uuid, ugid)

if not os.path.isfile(os.path.join(ihome, ".irodsA")):
    cmd = "iinit %s" % os.environ.get('ytfidopassword', '3nthr0py')
    subprocess.call(cmd, shell=True)

# Mount iRODS resources
cwd = os.getcwd()
for directory in json.loads(os.environ.get('mounts', '[]')):
    os.chdir("/mnt/data")
    path = urlparse.urlparse(directory).path
    target = os.path.join("/mnt/data", os.path.basename(path))
    os.mkdir(target)
    cmd = 'icd ' + path + ' && ' + 'irodsFs -o allow_other ' + target
    subprocess.call(cmd, shell=True)

# os.chdir("fuse")
if len(sys.argv) == 2:
    os.execlp("python2.7", "-u", sys.argv[1])
else:
    # os.execlp("ipython", "notebook")  # for some reason this just open
    # ipython shell
    subprocess.call("ipython notebook", shell=True)
os.chdir(cwd)
