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
	cross-release-container \
	helm-chart-release

all: build-container

# VERSION is the version of the binary.
VERSION ?= $(shell git describe --tags --dirty 2>/dev/null)

# TAG is the tag of the container image, default to binary version.
TAG?=$(VERSION)

# REGISTRY is the container registry to push into.
REGISTRY?=ghcr.io/daocloud

# IMAGE is the image name of the node problem detector container image.
IMAGE:=$(REGISTRY)/dao-2048:$(TAG)

# export TRIVY_DB_REPOSITORY=ghcr.m.daocloud.io/aquasecurity/trivy-db
TRIVY_DB_REPOSITORY?=ghcr.io/aquasecurity/trivy-db

TARGETS?=linux/arm,linux/arm64,linux/amd64

GITHUB_TOKEN?=

build-container: 
	@docker build -t "$(IMAGE)" --file ./Dockerfile .
# docker build -t $(IMAGE) --build-arg LOGCOUNTER=$(LOGCOUNTER) .

release-container: build-container
	@docker push $(IMAGE)

test: build-container
	@docker rm -f dao-2048-test || true
	@docker run --name dao-2048-test -d -p 8080:80 $(IMAGE)
	@curl --output /dev/null --silent --head --fail 127.0.0.1:8080	
	@docker rm -f dao-2048-test

cve-scan: build-container
	trivy i --exit-code 1 --severity HIGH,CRITICAL --db-repository=$(TRIVY_DB_REPOSITORY) $(IMAGE)

cross-build-container:
	@docker buildx build  --platform $(TARGETS) -t "$(IMAGE)" --file ./Dockerfile .

cross-release-container: cross-build-container
	@docker buildx build  --platform $(TARGETS) -t "$(IMAGE)" --push --file ./Dockerfile .

# git reset --hard first
# run `make helm-chart-release`
# then commit index.yaml to the gh-pages branch
helm-chart-release:
	@rm -rf index.yaml 
	@rm -rf .cr-release-packages
	@cp README.md charts/
	@sed 's/VERSION/$(VERSION)/g' charts/Chart.sed.yaml > charts/Chart.yaml
	@sed 's/VERSION/$(VERSION)/g' charts/values.sed.yaml > charts/values.yaml
	@cr package charts/
	@cr upload -o daocloud -r dao-2048 -t $(GITHUB_TOKEN) --skip-existing
	@helm repo index .
	@cr index -o daocloud -r dao-2048 -t $(GITHUB_TOKEN) -c http://daocloud.github.io/dao-2048/ -i index.yaml

