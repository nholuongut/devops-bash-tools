#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/github.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Merges one branch into another in the current or given repo, creating and merging Pull Requests for full audit tracking all changes

Useful to automate code promotion across environment branches or to automatically backport hotfixes from Production branch to dev / trunk branches

Also works across repo forks if the head branch contains an '<owner>:' prefix

Useful Git terminology reminder:

The HEAD branch is the branch you want to merge FROM, eg. 'my-feature-branch'
The BASE branch is the branch you want to merge INTO, eg. 'master' or 'main'

Requires GitHub CLI to be installed and configured

Depends on adjacent script:

    github_pull_request_create.sh

Used by adjacent script:

    github_repo_fork_update.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<owner>/<repo>] <from_head_branch> <to_base_branch>"

help_usage "$@"

min_args 2 "$@"
max_args 3 "$@"

output="$("$srcdir/github_pull_request_create.sh" "$@")"

if [ -n "$output" ]; then
    url="$(parse_pull_request_url "$output")"
    timestamp "Merging Pull Request:  $url"
    gh pr merge --merge "$url"
    echo >&2
fi
