#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


# https://www.jetbrains.com/help/teamcity/rest-api-reference.html#Build+Requests

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists the last 100 Teamcity builds and their results via the Teamcity API

Output format:

<Number>    <BuildType_ID>    <Build_ID>    <State>    <Status>

Specify \$NO_HEADER to omit the header line

See adjacent teamcity_api.sh for authentication details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

{
if [ -z "${NO_HEADER:-}" ]; then
    printf 'Num\tBuildType_ID\tBuild_ID\tState\tStatus\n'
fi
"$srcdir/teamcity_api.sh" /builds |
jq -r '.build[] | [.number, .buildTypeId, .id, .state, .status] | @tsv'
} |
column -t
