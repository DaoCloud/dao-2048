# Using a compact OS
ARG BASEIMAGE

FROM "${BASEIMAGE}"

# Add 2048 stuff into Nginx server
COPY . /usr/share/nginx/html

EXPOSE 80

# Start Nginx and keep it running background and start php
CMD bash scripts/start.sh
