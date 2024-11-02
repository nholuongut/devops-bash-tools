#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# https://docs.github.com/en/rest/reference/repos#update-a-repository

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Disables the Wiki on one or more given GitHub repos (to prevent scattered documentation instead of using say Confluence or Slite)

For authentication and other details see:

    github_api.sh --help
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<organization> <repo> [<repo2> <repo3> ...]"

help_usage "$@"

min_args 2 "$@"

org="$1"
shift || :

disable_repo_wiki(){
    local repo="$1"
    timestamp "disabling wiki on GitHub organization '$org' repo '$repo'"
    "$srcdir/github_api.sh" "/repos/$org/$repo" -X PATCH -d '{"has_wiki": false}' |
    jq -e -r '[ "Wiki Enabled: ", .has_wiki ] | @tsv'
}

for repo in "$@"; do
    disable_repo_wiki "$repo"
done
