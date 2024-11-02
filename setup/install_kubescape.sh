#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash
