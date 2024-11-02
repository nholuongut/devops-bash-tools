#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Rebuilds the last cancelled build for each pipeline in BuildKite via its API

See adjacent scripts for more details:

    buildkite_foreach_pipeline.sh
    buildkite_rebuild_failed_builds.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

"$srcdir/buildkite_foreach_pipeline.sh" "$srcdir/buildkite_rebuild_cancelled_builds.sh" '{pipeline}' 1

# All Cancelled builds in history
#
#"$srcdir/buildkite_api.sh" "builds?state=canceled" "$@" |
#jq -r '.[] | [.pipeline.slug, .number, .url] | @tsv' |
#while read -r name number url; do
#    url="${url#https://api.buildkite.com/v2/}"
#    echo -n "Rebuilding $name build number $number:  "
#    "$srcdir/buildkite_api.sh" "$url/rebuild" -X PUT |
#    jq -r '.state'
#done
