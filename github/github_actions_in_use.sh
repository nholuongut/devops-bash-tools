#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/git.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds all GitHub Actions directly referenced in the .github/workflows in the current local repo checkout

This is useful to combine with

    github_actions_repo_actions_allow.sh
        and
    github_actions_repos_lockdown.sh

Add these actions you need to ~/.github/workflows/allowed-actions.txt and then run github_actions_repos_lockdown.sh

Caveat: does not detect GitHub Actions referenced in reusable workflows - for that instead use github_actions_in_use_repo.sh which follows GitHub Reusable Workflows references in GitHub via the API
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#min_args 1 "$@"

git_root="$(git_root)"

# filtering out anything with .github in it as that will be a .github/workflows/file.yaml, not an action
grep -ERho '^[^#]+[[:space:]]uses:.+@[^#[:space:]]+' "$git_root/.github/workflows/" |
sed '
    s/^[^#]*[[:space:]]uses:[[:space:]]*//;
    s/#.*$//;
    s/[[:space:]]*$//;
    /\.github/d
' |
sort -fu
