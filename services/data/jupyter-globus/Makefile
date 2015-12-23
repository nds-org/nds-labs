IMAGES	= jupyter-scipy-globus
ORG 	= NDS
VERSION = 1.0

include ~/src/nds/labs/devtools/Makefiles/Makefile.nds

test:
	docker run --rm -it --ipc=host  --pid=host -v /dev/shm:/dev/shm -v /var/run/dbus:/var/run/dbus -v /tmp:/tmp -e `env | grep SESSION_MANAGER` -e `env | grep DISPLAY` -e `env | grep XAUTHORITY` $(IMAGES) bash
