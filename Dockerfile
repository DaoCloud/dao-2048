# Using a compact OS
# FROM docker.m.daocloud.io/nginx:1.23.0-alpine
FROM nginx:1.25.3-alpine

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Add 2048 stuff into Nginx server
COPY . /usr/share/nginx/html
EXPOSE 80
# Start Nginx and keep it running background and start php
CMD sh /usr/share/nginx/html/scripts/start.sh
