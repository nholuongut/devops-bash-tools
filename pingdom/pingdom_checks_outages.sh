#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists the status periods (outages) for all Pingdom checks for the last year (now - 12 months) via the Pingdom API

Output format - quoted CSV:

\"<status>\",\"<duration_in_seconds>\",\"<from_timestamp>\",\"<to_timestamp>\"

For TSV format, set TSV=1 environment variable

If you only want the outages just pipe it through:

    | grep -Ev '^\"?up'


\$PINGDOM_TOKEN must be defined in the environment for authentication

See adjacent pingdom_api.sh for more details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

"$srcdir/pingdom_foreach_check.sh" "$srcdir/pingdom_check_outages.sh" "{id}"
