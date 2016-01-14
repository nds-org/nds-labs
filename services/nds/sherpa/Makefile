IMAGES	= sherpactl-dev sherpactl # sherpa-webpull # sherpa-git sherpa-globus
ORG 	= NDS
VERSION = 1.0
include $(NDSLABS_SRC)/devtools/Makefiles/Makefile.nds


$(IMAGE.sherpactl): $(BUILDDIR)/sherpactl sherpactl.go
#
# Build the sherpa binary in $(DEPS)
# dev image builds the binary and installs in /build
# 
$(BUILDDIR)/sherpactl: $(IMAGE.sherpactl-dev)
	docker run --rm -v `pwd`/$(BUILDDIR):/build sherpactl-dev

test-live:
	docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`:/go/src/sherpactl sherpactl-dev bash

test-sherpa: 
	$(BUILDDIR)/sherpactl
	
