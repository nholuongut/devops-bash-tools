#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists the Pingdom checks and their status via the Pingdom API

Output format:

<check_id>  <check_name>      <type>      <hostname>    <status>    <last_response_time_in_ms>


From https://docs.pingdom.com/api/#section/Best-Practices/Use-common-sense:

\"Don't check for the status of a check every other second. The highest check resolution is one minute. Checking more often than that won't give you much of an advantage\"


\$PINGDOM_TOKEN must be defined in the environment for authentication

See adjacent pingdom_api.sh for more details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

"$srcdir/pingdom_api.sh" /checks "$@" |
jq -r ".checks[] | [.id, .name, .type, .hostname, .status, .lastresponsetime] | @csv" |
column -t -s , |
sed 's/"//g'
