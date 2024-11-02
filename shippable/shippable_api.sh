#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_description="Queries the Shippable API, auto-populating the base and API tokens from the environment"
# shellcheck disable=SC2034
usage_args="/path [<curl_options>]"

if [ -z "${SHIPPABLE_TOKEN:-}" ]; then
    usage "SHIPPABLE_TOKEN environment variable is not set (generate this from your Web UI Dashboard -> profile -> API AUTH TOKENS"
fi

if [ $# -lt 1 ]; then
    usage "no /path given to query in the API"
fi

help_usage "$@"

url_path="${1##/}"
shift || :

export TOKEN="$SHIPPABLE_TOKEN"

# non-standard auth header
export CURL_AUTH_HEADER="Authorization: apiToken"

"$srcdir/../bin/curl_auth.sh" -sS --fail "https://api.shippable.com/$url_path" "$@"
