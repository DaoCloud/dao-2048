# Using a compact OS
FROM alpine:latest

MAINTAINER Golfen Guo <golfen.guo@daocloud.io> 

# Install and configure Nginx
RUN apk --update add nginx
RUN sed -i "s#root   html;#root   /usr/share/nginx/html;#g" /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
	
# Add 2048 stuff into Nginx server
COPY . /usr/share/nginx/html

EXPOSE 80

# Start Nginx and keep it from running background
CMD ["nginx", "-g", "pid /tmp/nginx.pid; daemon off;"]

