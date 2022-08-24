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

GIT_TAG ?= $(shell git describe --tags --abbrev=0 --exact-match 2>/dev/null)
GIT_TAG_SHA ?= $(shell git describe --tags --dirty 2>/dev/null)

# TAG is the tag of the container image, default to binary version.
TAG?=$(GIT_TAG_SHA)

# Clear the "unreleased" string in BuildMetadata
ifneq ($(GIT_TAG),)
	TAG = ${GIT_TAG}
endif

# REGISTRY is the container registry to push into.
REGISTRY?=ghcr.io/daocloud

# IMAGE is the image name of the node problem detector container image.
IMAGE:=$(REGISTRY)/dao-2048:$(TAG)
IMAGE_NGINX:=$(REGISTRY)/dao-2048-nginx:$(TAG)
IMAGE_STATIC:=$(REGISTRY)/dao-2048-static:$(TAG)

# export TRIVY_DB_REPOSITORY=ghcr.m.daocloud.io/aquasecurity/trivy-db
TRIVY_DB_REPOSITORY?=ghcr.io/aquasecurity/trivy-db

TARGETS?=linux/arm,linux/arm64,linux/amd64

build-container: 
	@echo "Build Image: $(IMAGE)"
	@docker build -t "$(IMAGE_NGINX)" --file ./Dockerfile.nginx .
	@docker build -t "$(IMAGE_STATIC)" --file ./Dockerfile.static .
	@docker tag $(IMAGE_NGINX) $(IMAGE)

release-container: build-container
	@docker push $(IMAGE_NGINX)
	@docker push $(IMAGE_STATIC)
	@docker push $(IMAGE)

test: build-container
	@docker rm -f dao-2048-test || true
	@docker run --name dao-2048-test -d -p 8080:80 $(IMAGE_NGINX)
	@sleep 1
	@curl --output /dev/null --silent --head --fail 127.0.0.1:8080	
	@docker rm -f dao-2048-test
	@docker run --name dao-2048-test -d -p 8081:80 $(IMAGE_STATIC)
	@sleep 1
	@curl --output /dev/null --silent --head --fail 127.0.0.1:8081
	@docker rm -f dao-2048-test


cve-scan: build-container
	trivy i --exit-code 1 --severity CRITICAL --db-repository=$(TRIVY_DB_REPOSITORY) $(IMAGE_NGINX)
	trivy i --exit-code 1 --severity CRITICAL --db-repository=$(TRIVY_DB_REPOSITORY) $(IMAGE_STATIC)

cross-build-container:
	@docker buildx build  --platform $(TARGETS) -t "$(IMAGE_NGINX)" --file ./Dockerfile.nginx .
	@docker buildx build  --platform $(TARGETS) -t "$(IMAGE_STATIC)" --file ./Dockerfile.static .

cross-release-container: cross-build-container
	@docker buildx build  --platform $(TARGETS) -t "$(IMAGE_NGINX)" --push --file ./Dockerfile.nginx .
	@docker buildx build  --platform $(TARGETS) -t "$(IMAGE_STATIC)" --push --file ./Dockerfile.static .
	@docker buildx build  --platform $(TARGETS) -t "$(IMAGE)" --push --file ./Dockerfile.nginx .

GITHUB_OWNER?=daocloud
GITHUB_REPO?=dao-2048
GITHUB_TOKEN?=

helm-chart-release:
	@cr package charts
	@cr upload -o $(GITHUB_OWNER) -r $(GITHUB_REPO) -t $(GITHUB_TOKEN)
	@helm repo index .
	@cr index -o $(GITHUB_OWNER) -r $(GITHUB_REPO) -t $(GITHUB_TOKEN) --pr -i index.yaml -c https://daocloud.github.io/dao-2048/

clean:
	rm -rf .cr-*
