#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck source=lib/git.sh
. "$srcdir/lib/git.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists a GitHub repo's teams and their role name permissions using the GitHub API

If no repo is given, infers from local repo's git remotes

Output format:

<repo>  <team1>  <permission>
<repo>  <team2>  <permission>

This is most useful for GitHub Enterprise repos that are part of an organization to audit access across repos, especially when combined with github_foreach_repo.sh.
For many personal repos where you haven't invited collaborators, you will get no results, just as you will see in the GitHub UI a message like \"You haven't invited any collaborators yet\" on the page https://github.com/<user>/<repo>/settings/access
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo>"

help_usage "$@"

#min_args 1 "$@"

repo="${1:-}"

if [ -z "$repo" ]; then
    repo="$(git_repo)"
fi

"$srcdir/github_api.sh" "/repos/$repo/teams" |
jq -r ".[] | [\"$repo\", .slug, .permission] | @tsv" |
column -t
