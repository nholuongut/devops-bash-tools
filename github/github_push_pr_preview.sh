#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/github.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Pushes the current branch to GitHub origin, setting upstream branch, then opens a Pull Request preview from this to the given or default branch

Assumes that GitHub is the remote origin, and checks for this for safety
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<target_base_branch> <head_branch>]"

help_usage "$@"

#min_args 1 "$@"
max_args 2 "$@"

check_github_origin

current_branch="$(current_branch)"

git push --set-upstream origin "$current_branch"

"$srcdir/github_pull_request_preview.sh" "$@"
