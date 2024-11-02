#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

curl https://get.datree.io | /bin/bash
echo

if [ -n "${DATREE_TOKEN:-}" ]; then
    echo "\$DATATREE_TOKEN found, configuring..."
    datree config set token "$DATREE_TOKEN"
fi

echo
echo -n "Datree version: "
datree version
