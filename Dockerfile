# Using a compact OS
# FROM docker.m.daocloud.io/nginx:1.23.0-alpine
FROM nginx:1.23.0-alpine

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache bash

# Add 2048 stuff into Nginx server
COPY . /usr/share/nginx/html
EXPOSE 80
# Start Nginx and keep it running background and start php
CMD bash /usr/share/nginx/html/scripts/start.sh
