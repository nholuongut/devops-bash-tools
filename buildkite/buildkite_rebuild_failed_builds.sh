#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/git.sh"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_description="
Rebuilds the last N failed builds in BuildKite via its API

Useful to retrying N builds across projects where they may have failed due to agent problems

https://buildkite.com/docs/apis/rest-api/builds
"

# shellcheck disable=SC2034
usage_args="<pipeline> [<num_builds>]"

help_usage "$@"

#min_args 1 "$@"

pipeline="${1:-$(git_repo_name_lowercase)}"

num="${2:-10}"

if ! is_int "$num"; then
    usage "num builds must be an integer"
fi

if [ "$num" -lt 1 ] || [ "$num" -gt 100 ]; then
    usage "num builds must be an integer between 1 and 100"
fi

# shellcheck disable=SC2154
"$srcdir/buildkite_api.sh" "/organizations/{organization}/pipelines/$pipeline/builds?state=failed&per_page=$num" |
jq -r '.[] | [.pipeline.slug, .number, .url] | @tsv' |
while read -r name number url; do
    echo -n "Rebuilding $name build number $number:  "
    "$srcdir/buildkite_api.sh" "$url/rebuild" -X PUT |
    jq -r '.state'
done
