#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: devops-bash-tools

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Sets a given BuildKite pipeline's description to match its source GitHub repo's description
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<pipeline>"

help_usage "$@"

min_args 1 "$@"

pipeline="$1"
shift || :

repo="$("$srcdir/buildkite_get_pipeline.sh" "$pipeline" | jq -r .repository)"

if ! [[ $repo =~ github.com ]]; then
    die "ERROR: source repository for pipeline '$pipeline' is not GitHub.com - sync'ing description from other VCS providers is not supported at this time"
fi

repo="${repo##github.com/}"

"$srcdir/../github/github_repo_description.sh" "$repo" |
while read -r repo description; do
    "$srcdir/buildkite_set_pipeline_description.sh" "$pipeline" "$description"
done
