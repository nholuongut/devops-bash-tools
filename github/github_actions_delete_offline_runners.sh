#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# https://docs.github.com/en/rest/reference/actions#delete-a-self-hosted-runner-group-from-an-organization
#
# https://docs.github.com/en/rest/reference/actions#delete-a-self-hosted-runner-from-a-repository

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Deletes offline GitHub Actions self-hosted runners for the given Repo or Organization via the GitHub API

Uses github_actions_runners.sh to find offline runners

See Also:

    github_actions_runner.sh - generates a token and launches a runner for a GitHub Organization or Repo

    https://github.com/nholuongut/Kubernetes-configs - for running GitHub Actions Runners in Kubernetes
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo_or_organization>"

help_usage "$@"

min_args 1 "$@"

repo_or_org="$1"
shift

"$srcdir/github_actions_runners.sh" "$repo_or_org" |
awk '$2~/offline/{print $1}' |
while read -r id; do
    if [[ "$repo_or_org" =~ / ]]; then
        prefix="repos"
    else # is an org
        prefix="orgs"
    fi
    timestamp "deleting offline runner with id '$id'"
    "$srcdir/github_api.sh" "/$prefix/$repo_or_org/actions/runners/$id" -X DELETE
done
