#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Cancels BuildKite running builds via its API (to clear them and restart new later eg. after agent / environment change / fix)

https://buildkite.com/docs/apis/rest-api/builds
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

"$srcdir/buildkite_api.sh" 'builds?state=running' "$@" |
jq -r '.[] | [.pipeline.slug, .number, .url] | @tsv' |
while read -r name number url; do
    url="${url#https://api.buildkite.com/v2/}"
    echo -n "Cancelling $name build number $number:  "
    "$srcdir/buildkite_api.sh" "$url/cancel" -X PUT |
    jq -r '.state'
done
