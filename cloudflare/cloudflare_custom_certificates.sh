#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
For a given Cloudflare zone, list the custom certificates

Output format:

<id>    <expiry_date>    <status>    <hosts>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<zone_id>"

help_usage "$@"

min_args 1 "$@"

zone_id="$1"

"$srcdir/cloudflare_api.sh" "/zones/$zone_id/custom_certificates" | jq -r '.result[] | [ .expires_on, .status, (.hosts | join(",")) ] | @tsv'
