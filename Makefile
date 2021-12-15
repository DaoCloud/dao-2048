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
        vet fmt version test e2e-test \
        build-binaries build-container build-tar build \
        docker-builder build-in-docker push-container push-tar push clean

all: build

# PLATFORMS is the set of OS_ARCH that NPD can build against.
LINUX_PLATFORMS=linux_amd64 linux_arm64
PLATFORMS=$(LINUX_PLATFORMS) windows_amd64

# VERSION is the version of the binary.
VERSION?=$(shell if [ -d .git ]; then echo `git describe --tags --dirty`; else echo "UNKNOWN"; fi)

# TAG is the tag of the container image, default to binary version.
TAG?=$(VERSION)

# REGISTRY is the container registry to push into.
REGISTRY?=gcr.io/k8s-staging-npd

# IMAGE is the image name of the node problem detector container image.
IMAGE:=$(REGISTRY)/node-problem-detector:$(TAG)

# TODO(random-liu): Support different architectures.
# The debian-base:v1.0.0 image built from kubernetes repository is based on
# Debian Stretch. It includes systemd 232 with support for both +XZ and +LZ4
# compression. +LZ4 is needed on some os distros such as COS.
BASEIMAGE:=k8s.gcr.io/debian-base-amd64:v1.0.0

build-container: build-binaries Dockerfile
	docker build -t $(IMAGE) --build-arg BASEIMAGE=$(BASEIMAGE) --build-arg LOGCOUNTER=$(LOGCOUNTER) .
