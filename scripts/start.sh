#!/usr/bin/env bash

PODINFO=""
PODINFO+="<p><strong class=\"important\">HOST_NAME:</strong>$(hostname)</p>"
if [ $NODE_NAME ]
then
PODINFO+="<p><strong class=\"important\">NODE_NAME:</strong>$NODE_NAME</p>"
fi
if [ $POD_NAME ]
then
PODINFO+="<p><strong class=\"important\">POD_NAME:</strong>$POD_NAME</p>"
fi
if [ $POD_NAMESPACE ]
then
PODINFO+="<p><strong class=\"important\">POD_NAMESPACE:</strong>$POD_NAMESPACE</p>"
fi
echo $PODINFO > podinfo.txt
sed -i "/<div id=\"podinfo\" class=\"game-explanation\">/r podinfo.txt" /usr/share/nginx/html/index.html
nginx -g "daemon off;"
