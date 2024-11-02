#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: Dockerfile

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds files matching the given name in the current or given GitHub repo using the GitHub CLI


Requires GitHub CLI to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<filename_regex> [<owner>/<repo>]"

help_usage "$@"

min_args 1 "$@"

filename="$1"
owner_repo="${2:-":owner/:repo"}"

gh api "/repos/$owner_repo/git/trees/HEAD?recursive=1" |
jq -r ".tree[]?.path | select(. | test(\"$filename\") )"
