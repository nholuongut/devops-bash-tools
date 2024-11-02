#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists all DNS records in Cloudflare across all zones

https://api.cloudflare.com/#dns-records-for-a-zone-list-dns-records

Output format:

<dns_record>    <type>    <ttl>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

"$srcdir/cloudflare_foreach_zone.sh" "$srcdir/cloudflare_dns_records.sh {zone_id}"
