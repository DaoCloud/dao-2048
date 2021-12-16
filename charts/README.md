# 2048

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/dao-2048)](https://artifacthub.io/packages/search?repo=dao-2048)

2048 is a number puzzle game. When the squares of the same number are merged together, they will add up. Each round will have an extra square with 2 or 4 written on it, and the game ends when the square cannot be moved. Players have to find a way to make up a square with **2048** (or larger) in this small 16 squares.

# Quick Start

## Run as docker container

open shell and input:

```
docker run -d -p 8080:80 ghcr.io/daocloud/dao-2048:$TAG
```

open browser and view http://<server-ip>:8080 .

## Run in kubernetes

```
helm repo add dao-2048 http://daocloud.github.io/dao-2048/
helm install my-release dao-2048/dao-2048
```


### Thanks

This image is derived from the Docker Hub image **[alexwhen/docker-2048](https://registry.hub.docker.com/u/alexwhen/docker-2048/)**, thanks to the developer**[alexwhen] (https://github.com/alexwhen)** enthusiastic support. And thanks to gabrielecirulli's [2048] (https://github.com/gabrielecirulli/2048) project
