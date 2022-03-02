# Copyright (C) 2022 Toitware ApS. All rights reserved.
# Use of this source code is governed by an MIT-style license that can be
# found in the LICENSE file.

FIRMWARE_MODEL   ?= armv5te-linux
FIRMWARE_VERSION ?= v1.6.9

.PHONY: all
all: build/toit-$(FIRMWARE_MODEL).tgz

build/toit-$(FIRMWARE_MODEL).tgz: build/toit/boot.sh build/toit/secret.ubjson build/toit/ota0/factory.txt
	tar -C build/ -czf $@ toit/

build/toit/boot.sh: skeleton/boot.sh
	mkdir -p $(dir $@)
	cp -R skeleton/* build/toit/.

build/toit/secret.ubjson: secret.ubjson
	mkdir -p $(dir $@)
	cp $< $@

build/toit/ota0/factory.txt: build/download/$(FIRMWARE_MODEL)-$(FIRMWARE_VERSION).tgz
	tar -C build/toit/ota0 -xf $<
	echo "$(FIRMWARE_MODEL)-$(FIRMWARE_VERSION)" > $@

build/download/$(FIRMWARE_MODEL)-$(FIRMWARE_VERSION).tgz:
	mkdir -p $(dir $@)
	(cd $(dir $@); toit firmware download $(FIRMWARE_MODEL) $(FIRMWARE_VERSION))

secret.ubjson:
	$(error Fetch a device identity using: toit device create-identity)

.PHONY: clean
clean:
	rm -rf build/
