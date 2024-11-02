#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/git.sh"

# shellcheck disable=SC2034
usage_description="
Triggers a BuildKite build job for a given pipeline

Pipeline can be given as an argumnent, or taken from \$BUILDKITE_PIPELINE / \$PIPELINE environment variables

Otherwise tries to infer from the current Git repository remote origin URL
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<pipeline> [<curl_options>]"

help_usage "$@"

if [ $# -gt 0 ]; then
    pipeline="$1"
    shift
else
    pipeline="${BUILDKITE_PIPELINE:-${PIPELINE:-$(git_repo_name_lowercase)}}"
fi

if [ -z "$pipeline" ]; then
    usage "\$BUILDKITE_PIPELINE not defined and no argument given"
fi

"$srcdir/buildkite_api.sh" "/organizations/{organization}/pipelines/$pipeline/builds" \
    -X "POST" \
    -F "commit=${BUILDKITE_COMMIT:-HEAD}" \
    -F "branch=${BUILDKITE_BRANCH:-master}" \
    -F "message=triggered by nholuongut nho ${0##*/} script" "$@"
