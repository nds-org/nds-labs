#!/usr/bin/env python2

import os
import sys
import subprocess
import urlparse
import json
from pwd import getpwnam


def mount_ideals():
    from ideals import IDEALSFilesystem
    import fs
    base_fs = fs.mountfs.MountFS()
    ifs = IDEALSFilesystem(base_fs)
    base_fs.mountdir("", ifs)
    xl_fn = "/Connecting to Collections/Arizona Survey Raw Data/AZ+Raw+Data.xls"
    mp = fs.expose.fuse.mount(base_fs, "/home/user/work/ideals/",
                              foreground=True)
    os._exit(0)


user = getpwnam("user")
uhome = user.pw_dir
uuid = user.pw_uid
ugid = user.pw_gid
ihome = os.path.join(uhome, ".irods")
if not os.path.isdir(ihome):
    os.mkdir(ihome, 0700)

if not os.path.isfile(os.path.join(ihome, ".irodsEnv")):
    host_ip = os.environ.get('COREOS_PRIVATE_IPV4', None)
    with open(os.path.join(ihome, ".irodsEnv"), 'w') as fh:
        fh.write("irodsHost %s\n" % os.environ.get('irodsHost', ''))
        fh.write("irodsPort %s\n" % os.environ.get('irodsPort', ''))
        fh.write("irodsZone %s\n" % os.environ.get('irodsZone', ''))
        fh.write("irodsUserName ytfido\n")

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

# Mount WebDAV access
pw = os.environ.get("WEBDAV_OTP", None)
host = os.environ.get("WEBDAV_HOST", None)
user = os.environ.get("WEBDAV_USER", None)
if None not in (pw, host, user):
    if not os.path.isdir("/home/user/.davfs2"):
        os.mkdir("/home/user/.davfs2")
    if not os.path.isdir("/home/user/work"):
        os.mkdir("/home/user/work")
    # Now we mount our WebDAV host using davfs2
    with open("/home/user/.davfs2/secrets", "w") as f:
        f.write("/home/user/work %s \"%s\"\n" %
                (user.replace("#", "\\#"), pw))
    with open("/home/user/.davfs2/davfs2.conf", "w") as f:
        f.write("use_locks 0\n")
    subprocess.call("chmod 600 /home/user/.davfs2/secrets", shell=True)
    cmd = "mount /home/user/work"
    subprocess.call(cmd, shell=True)
    if os.environ.get('MOUNT_IDEALS', 'NO') == "YES":
        newpid = os.fork()
        if newpid == 0:
            mount_ideals()

os.chdir(cwd)
if len(sys.argv) == 2:
    os.execlp("python2.7", "-u", sys.argv[1])
else:
    # for some reason this just open ipython shell
    # os.execlp("ipython", "notebook")
    os.environ.get("IPYTHONDIR", "/home/user/ipython-conf")
    subprocess.call("ipython notebook --profile=nbserver", shell=True)
