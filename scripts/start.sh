#!/usr/bin/env bash

# PODINFO=""
# PODINFO+="<p><strong class=\"important\">HOST_NAME:</strong>$(hostname)</p>"
# if [ $NODE_NAME ]
# then
# PODINFO+="<p><strong class=\"important\">NODE_NAME:</strong>$NODE_NAME</p>"
# fi
# if [ $POD_NAME ]
# then
# PODINFO+="<p><strong class=\"important\">POD_NAME:</strong>$POD_NAME</p>"
# fi
# if [ $POD_NAMESPACE ]
# then
# PODINFO+="<p><strong class=\"important\">POD_NAMESPACE:</strong>$POD_NAMESPACE</p>"
# fi
# echo $PODINFO > podinfo.txt
# sed -i "/<div id=\"podinfo\" class=\"game-explanation\">/r podinfo.txt" /usr/share/nginx/html/index.html

sed -i.bak -r 's/^(worker_processes)(.*)$/#\1\2\n\1 '"1"';/' /etc/nginx/nginx.conf
# sed -i 's/80;/[::]:80;/g' /etc/nginx/conf.d/default.conf

# Enhancement the security
cat <<EOT > /etc/nginx/conf.d/security.conf
server_tokens   off;
autoindex off;
EOT

/docker-entrypoint.sh nginx -g "daemon off;"
