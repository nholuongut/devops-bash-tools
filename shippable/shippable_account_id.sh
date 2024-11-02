#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# pending support ticket around permissions issue

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_description="Returns Shippable accounts for the given \$SHIPPABLE_TOKEN

Caveat: this API endpoint only works for paid accounts :-(

https://github.com/Shippable/support/issues/5068
"

help_usage "$@"

#curl -sSH 'Accept: application/json' 'https://api.shippable.com/projects?sortBy=createdAt&sortOrder=-1&ownerAccountIds=nholuongutnho'
"$srcdir/shippable_api.sh" '/accounts'
