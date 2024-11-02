#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Cloudflare DnsSec status for all zones

https://api.cloudflare.com/#dnssec-dnssec-details

Output format:

<zone_id>    <zone_name>    <dnssec_status>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#min_args 1 "$@"

export NO_HEADING=1

"$srcdir/cloudflare_foreach_zone.sh" "$srcdir/cloudflare_api.sh /zones/{id}/dnssec | jq -r \"[\\\"{id}\\\", \\\"{name}\\\", .result.status] | @tsv\""
