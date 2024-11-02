#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Gets Cloudflare zone SSL verification status for a given zone

Output format:

<hostname>  <status>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<zone>"

help_usage "$@"

min_args 1 "$@"

zone_id="$1"

"$srcdir/cloudflare_api.sh" "/zones/$zone_id/ssl/verification" |
jq -r '.result[] | [.hostname, .certificate_status] | @tsv' |
column -t
