#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
# https://www.jetbrains.com/help/teamcity/rest-api-reference.html#Agents

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists the Teamcity agents and their states via the Teamcity API

Output format:

<agent_id>  <connected>     <authorized>      <enabled>    <up_to_date>    <name>

Specify \$NO_HEADER to omit the header line

See adjacent teamcity_api.sh for authentication details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

{
if [ -z "${NO_HEADER:-}" ]; then
    printf 'Agent_ID\tConnected\tAuthorized\tEnabled\tUp_to_Date\tName\n'
fi
"$srcdir/teamcity_api.sh" /agents |
jq -r '.agent[].id' |
while read -r id; do
    "$srcdir/teamcity_api.sh" "/agents/id:$id" |
    jq -r '[.id, .connected, .authorized, .enabled, .uptodate, .name] | @tsv'
done
} |
column -t
