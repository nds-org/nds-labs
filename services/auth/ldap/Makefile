NAME = nds/nds-ldap
VERSION = 0.1
TAGNAME=$(NAME):$(VERSION)
# temp short name for ease of dev
TAGNAME=ndsldap

.PHONY: all build test tag_latest release ssh

all: build

build: Dockerfile
	docker build -t $(TAGNAME) --rm .

shell: 
	docker run --rm -it $(TAGNAME) bash

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./test/runner.sh

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

#release: test tag_latest
#	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
#	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
#	docker push $(NAME)
#	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
#
#ssh:
#	chmod 600 image/services/sshd/keys/insecure_key
#	@ID=$$(docker ps | grep -F "$(NAME):$(VERSION)" | awk '{ print $$1 }') && \
#		if test "$$ID" = ""; then echo "Container is not running."; exit 1; fi && \
#		IP=$$(docker inspect $$ID | grep IPAddr | sed 's/.*: "//; s/".*//') && \
#		echo "SSHing into $$IP" && \
#		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i image/services/sshd/keys/insecure_key root@$$IP
