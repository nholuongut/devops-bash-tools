#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Cloudflare Firewall Rules for a given Zone ID

In --verbose mode also also lists the filter expression at the end

Output:

<id>

Uses cloudflare_api.sh - see there for authentication API key details

See Also:

    cloudflare_zones.sh - to get the zone id argument
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<zone_id> [--verbose]"

help_usage "$@"

until [ $# -lt 1 ]; do
    case "$1" in
 -v|--verbose)  verbose=1
                ;;
           -*)  usage
                ;;
            *)  if [ -n "${zone_id:-}" ]; then
                    usage
                fi
                zone_id="$1"
                ;;
    esac
    shift || :
done

if [ -z "${zone_id:-}" ]; then
    usage "zone id not defined"
fi

"$srcdir/cloudflare_api.sh" "/zones/$zone_id/firewall/rules" |
if [ -n "${verbose:-}" ]; then
    jq -r '.result[] | [.id, .action, .description, .filter.expression] | @tsv'
else
    jq -r '.result[] | [.id, .action, .description] | @tsv'
fi
