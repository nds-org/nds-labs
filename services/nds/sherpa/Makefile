IMAGES	= sherpactl-dev sherpactl # sherpa-webpull # sherpa-git sherpa-globus
ORG 	= NDS
VERSION = 1.0
include $(NDSLABS_SRC)/devtools/Makefiles/Makefile.nds


IMAGE.sherpactl: $(BUILDDIR)/sherpactl
#
# Build the sherpa binary in $(DEPS)
# dev image builds the binary and installs in /build
# 
$(BUILDDIR)/sherpactl: IMAGE.sherpactl-dev
	docker run --rm -v `pwd`/$(DEPS):/build sherpactl-dev

livedev:
	docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`:/go/src/sherpactl sherpactl-dev bash
