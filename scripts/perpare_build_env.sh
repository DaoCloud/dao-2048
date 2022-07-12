#!/usr/bin/env bash

curl -sSLo cr.tar.gz "https://github.com/helm/chart-releaser/releases/download/v1.4.0/chart-releaser_1.4.0_linux_amd64.tar.gz"
tar -xzf cr.tar.gz
rm -f cr.tar.gz
chmod +x cr
mv cr /usr/local/bin