IMAGES	= clowderctl-dev clowderctl # clowder-webpull # clowder-git clowder-globus
ORG 	= NDS
VERSION = 1.0
include $(abspath ../../..)/devtools/Makefiles/Makefile.nds


IMAGE.clowderctl: $(BUILDDIR)/clowderctl
#
# Build the clowder binary in $(DEPS)
# dev image builds the binary and installs in /build
# 
$(BUILDDIR)/clowderctl: IMAGE.clowderctl-dev
	docker run --rm -v `pwd`/$(DEPS):/build clowderctl-dev

livedev:
	docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`:/go/src/clowderctl clowderctl-dev bash
