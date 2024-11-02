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
Lists a GitHub repo's stars and forks using the GitHub API

If no repo is given, infers from local repo's git remotes

Output format:

<repo>  <stars>  <forks>  <watchers>
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo> [<curl_options>]"

help_usage "$@"

#min_args 1 "$@"

repo="${1:-}"

if [ -z "$repo" ]; then
    repo="$(git_repo)"
fi

"$srcdir/github_api.sh" "/repos/$repo" |
jq -r '[.name, .stargazers_count, .forks, .watchers] | @tsv'
