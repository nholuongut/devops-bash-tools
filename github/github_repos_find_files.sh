#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: Dockerfile

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/github.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds files matching the given name across all repos in the current organization or user using the GitHub API & CLI

Output Format:

<owner>/<repo>    <file_path>
<owner>/<repo2>   <file_path2>


Requires GitHub CLI to be installed and configured, as well as the adjacent github_api.sh script
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<filename_regex>"

help_usage "$@"

min_args 1 "$@"

filename="$1"

owner="${GITHUB_ORGANIZATION:-${GITHUB_USER:-$(get_github_user)}}"

get_github_repos "$owner" "${GITHUB_ORGANIZATION:-}" |
while read -r repo; do
    gh api "/repos/$owner/$repo/git/trees/HEAD?recursive=1" |
    jq -r ".tree[]?.path | select(. | test(\"$filename\") )" |
    sed $"s|^|$owner/$repo\\t|"
done
