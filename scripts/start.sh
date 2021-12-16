#!/usr/bin/env bash

PODINFO=""

PODINFO+="<p><strong class=\"important\">HOST_NAME:</strong> $(hostname) </strong></p>"
if [ -n $NODE_NAME ]
then
PODINFO+="<p><strong class=\"important\">NODE_NAME:</strong> $NODE_NAME </strong></p>"
fi
if [ -n $POD_NAME ]
then
PODINFO+="<p><strong class=\"important\">POD_NAME:</strong> $POD_NAME </strong></p>"
fi
if [ -n $POD_NAMESPACE ]
then
PODINFO+="<p><strong class=\"important\">POD_NAMESPACE:</strong> $POD_NAMESPACE </strong></p>"
fi
echo sed -i "s+PODINFO+\'$PODINFO\'+g" /usr/share/nginx/html/index.html
nginx -g "daemon off;"
