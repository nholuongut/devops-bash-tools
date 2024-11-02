#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# https://github.com/fossas/fossa-cli

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/fossas/fossa-cli/master/install-latest.sh | bash
