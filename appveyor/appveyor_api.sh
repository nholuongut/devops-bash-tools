#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
# eg.
#
# appveyor_api.sh projects | jq

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_description="Queries the AppVeyor API, auto-populating the base and API tokens from the environment"
# shellcheck disable=SC2034
usage_args="/path [<curl_options>]"

if [ -z "${APPVEYOR_TOKEN:-}" ]; then
    usage "APPVEYOR_TOKEN environment variable is not set (generate this from your Web UI Dashboard -> profile -> API AUTH TOKENS"
fi

if [ $# -lt 1 ]; then
    usage "no /path given to query in the API"
fi

for arg; do
    case "$arg" in
        -h|--help) usage
                   ;;
   esac
done

url_path="${1##/}"
shift || :

export TOKEN="$APPVEYOR_TOKEN"

"$srcdir/../bin/curl_auth.sh" -sS --fail "https://ci.appveyor.com/api/$url_path" "$@"
