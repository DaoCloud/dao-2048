# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.PHONY: all \
	build-container \
	release-container \
	cross-build-container \
	cross-release-container

all: build-container

# VERSION is the version of the binary.
VERSION?=$(shell if [ -d .git ]; then echo `git describe --tags --dirty`; else echo "UNKNOWN"; fi)

# TAG is the tag of the container image, default to binary version.
TAG?=$(VERSION)

# REGISTRY is the container registry to push into.
REGISTRY?=ghcr.io/daocloud

# IMAGE is the image name of the node problem detector container image.
IMAGE:=$(REGISTRY)/dao-2048:$(TAG)

BASEIMAGE?=nginx:1.20.2-alpine

build-container: 
	@docker build --build-arg BASEIMAGE=$(BASEIMAGE) -t "$(IMAGE)" --file ./Dockerfile .
# docker build -t $(IMAGE) --build-arg BASEIMAGE=$(BASEIMAGE) --build-arg LOGCOUNTER=$(LOGCOUNTER) .

release-container: build-container
	@docker push $(IMAGE)

cross-build-container:
	@echo "haha" + "$(IMAGE)" 

cross-release-container: cross-build-container
	@echo "haha" + "$(IMAGE)" 


# do-something:
# 	@echo "doing something"
# 	@echo "running tests $(TESTS)"
# 	@exit 1