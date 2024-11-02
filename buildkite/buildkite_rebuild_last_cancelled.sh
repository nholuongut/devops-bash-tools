#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_description="
Rebuilds the last cancelled build for each pipeline in BuildKite via its API (after clearing a backlog due to offline agents by cancelling all scheduled builds)

https://buildkite.com/docs/apis/rest-api/builds

May fail with Forbidden if your trial account has expired (renew or contact support to switch to free account to get API working again)
"

# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

"$srcdir/buildkite_api.sh" "organizations/{organization}/pipelines" "$@" |
jq -r '.[].slug' |
while read -r pipeline; do
    "$srcdir/buildkite_api.sh" "organizations/{organization}/pipelines/$pipeline/builds?state=canceled" "$@" |
    jq -r 'limit(1; .[] | [.pipeline.slug, .number, .url] | @tsv)' |
    while read -r name number url; do
        url="${url#https://api.buildkite.com/v2/}"
        echo -n "Rebuilding $name build number $number:  "
        "$srcdir/buildkite_api.sh" "$url/rebuild" -X PUT |
        jq
    done
done
