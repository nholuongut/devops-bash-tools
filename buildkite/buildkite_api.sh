#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Queries BuildKite API, auto-populating \$BUILDKITE_TOKEN from environment and API url base for convenience

https://buildkite.com/docs/apis/rest-api

Examples:

    ${0##*/} /user | jq .

    ${0##*/} /organizations | jq .

    ${0##*/} /organizations/{organization}/pipelines | jq .

    ${0##*/} /organizations/{organization}/pipelines/{pipeline} | jq .

    ${0##*/} /builds | jq .

    ${0##*/} /organizations/{organization}/builds | jq .

    ${0##*/} /organizations/{organization}/pipelines/{pipeline}/builds/<num> | jq .

    ${0##*/} /organizations/{organization}/agents | jq .

    ${0##*/} /organizations/{organization}/emojis | jq .


Replacements:

{organization}    \$BUILDKITE_ORGANIZATION, \$BUILDKITE_USER, or queries /organizations (if more than one org is found you must set \$BUILDKITE_ORGANIZATION to avoid ambiguity)
{pipeline}        \$BUILDKITE_PIPELINE
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="/path [<curl_options>]"

if [ -z "${BUILDKITE_TOKEN:-}" ]; then
    usage "BUILDKITE_TOKEN environment variable is not set (generate this from the Web UI -> Personal Settings -> API Access Tokens (https://buildkite.com/user/api-access-tokens)"
fi

if [ $# -lt 1 ]; then
    usage "no /path given to query in the API"
fi

help_usage "$@"

min_args 1 "$@"

url_base="https://api.buildkite.com/v2"

url_path="$1"
shift || :

url_path="${url_path#$url_base}"
url_path="${url_path##/}"

export TOKEN="$BUILDKITE_TOKEN"

# remember to set this eg. BUILDKITE_ORGANIZATION="{organization}"
BUILDKITE_ORGANIZATION="${BUILDKITE_ORGANIZATION:-${BUILDKITE_USER:-}}"

if [[ "$url_path" =~ {organization} ]]; then
    organizations="$("$srcdir/../bin/curl_auth.sh" -sS --fail "$url_base/organizations" | jq -r '.[].slug')"
    num_organizations="$(wc -w <<< "$organizations" | sed 's/[[:space:]]//g')"
    if [ "$num_organizations" -eq 0 ]; then
        usage "\$BUILDKITE_ORGANIZATION / \$BUILDKITE_USER not set and could not find any organizations for the \$BUILDKITE_TOKEN"
    elif [ "$num_organizations" -eq 1 ]; then
        BUILDKITE_ORGANIZATION="$organizations"
        url_path="${url_path//\{organization\}/$BUILDKITE_ORGANIZATION}"
    elif [ "$num_organizations" -gt 1 ]; then
        usage "\$BUILDKITE_ORGANIZATION / \$BUILDKITE_USER not set and found more than 1 organization registered to the \$BUILDKITE_TOKEN - must specify \$BUILDKITE_ORGANIZATION to avoid ambiguity"
    fi
fi

if [[ "$url_path" =~ {pipeline} ]]; then
    if [ -z "$BUILDKITE_PIPELINE" ]; then
        usage "\$BUILDKITE_PIPELINE is not set, cannot do replacement of {pipeline} given in the url path"
    fi
    url_path="${url_path//\{pipeline\}/$BUILDKITE_PIPELINE}"
fi

"$srcdir/../bin/curl_auth.sh" -sS --fail "$url_base/$url_path" "$@"
