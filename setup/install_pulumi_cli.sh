#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# installs to ~/.pulumi/bin/
curl -fsSL https://get.pulumi.com | sh
echo
~/.pulumi/bin/pulumi version
