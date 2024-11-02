#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

pip install caniusepython3
echo "Testing module dependencies for Python 3 compatibility"
caniusepython3 -r requirements.txt
