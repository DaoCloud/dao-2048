.PHONY: all \
	build-container \
	release-container

all: build-container

# REGISTRY is the container registry to push into.
IMAGE?=ghcr.io/daocloud/dao-2048/nginx-sw64

build-container: 
	@echo "Build Image: $(IMAGE)"
	docker build -t "$(IMAGE)" .

release-container: build-container
	@docker push $(IMAGE)