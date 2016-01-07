IMAGES	= sherpa-dev sherpactl sherpa-webpull # sherpa-git sherpa-globus
ORG 	= NDS
VERSION = 1.0

#
# Build the sherpa binary in $(DEPS)
# dev image builds the binary and installs in /build
# 
DEPS.sherpactl := $(DEPS)/sherpactl

$(DEPS)/sherpactl: IMAGE.sherpactl-dev
	docker run --rm -v `pwd`/$(DEPS):/build

include $(NDSLABS_SRC)/devtools/Makefiles/Makefile.nds
