#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Returns the number of Pingdom available SMS credits checks via the Pingdom API

\$PINGDOM_TOKEN must be defined in the environment for authentication

See adjacent pingdom_api.sh for more details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

"$srcdir/pingdom_api.sh" /credits "$@" |
jq -r '.credits.availablesms'
