# Using a compact OS
FROM daocloud.io/nginx:1.11-alpine

MAINTAINER Golfen Guo <golfen.guo@daocloud.io> 

# Add 2048 stuff into Nginx server
COPY . /usr/share/nginx/html

EXPOSE 80

# Start Nginx and keep it from running background
CMD ["nginx", "-g", "daemon off;"]
