#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Gets Cloudflare zone SSL verification status for all zones

Output format:

<hostname>  <status>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

"$srcdir/cloudflare_foreach_zone.sh" "$srcdir/cloudflare_ssl_verified.sh {zone_id}"
