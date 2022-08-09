all: build install

.PHONY: sources spec clean-spec srpm

GIT = $(shell which git)
# DIST ?= epel-7-x86_64

PACKAGE = koji-test-rpm
VERSION = $(shell rpm -q --qf "%{version}\n" --specfile $(PACKAGE).spec | head -1)
RELEASE = $(shell rpm -q --qf "%{release}\n" --specfile $(PACKAGE).spec | head -1)

ifdef GIT
HEAD_SHA := $(shell git rev-parse --short --verify HEAD)
TAG      := $(shell git show-ref --tags -d | grep $(HEAD_SHA) | \
		git name-rev --tags --name-only $$(awk '{print $2}'))
endif

BUILDID := %{nil}

ifndef TAG
BUILDID := .$(shell date --date="$$(git show -s --format=%ci $(HEAD_SHA))" '+%Y%m%d%H%M').git$(HEAD_SHA)
endif


spec:
	@git cat-file -p $(HEAD_SHA):$(PACKAGE).spec | sed -e 's,@BUILDID@,$(BUILDID),g' > $(PACKAGE).spec

sources: clean spec
	@git archive --format=tar --prefix=$(PACKAGE)-$(VERSION)/ $(HEAD_SHA) | \
		gzip > $(PACKAGE)-$(VERSION).tar.gz

clean-spec:
	@git checkout $(PACKAGE).spec

clean: clean-spec
	@rm -rf build dist srpms rpms $(PACKAGE)-*.tar.gz
