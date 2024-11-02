#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# https://docs.github.com/en/rest/reference/actions#create-a-registration-token-for-an-organization
#
# https://docs.github.com/en/rest/reference/actions#create-a-registration-token-for-a-repository

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Generates a GitHub Actions Runner token for the given Repo or Organization via the GitHub API and then runs a Dockerized GitHub Actions runner with the appropriate configuration

See Also:

    https://github.com/nholuongut/Kubernetes-configs - for running GitHub Actions Runners in Kubernetes
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo_or_organization> [<runner_config_options>]"

help_usage "$@"

min_args 1 "$@"

repo_or_org="$1"
shift

token="$("$srcdir/github_actions_runner_token.sh" "$repo_or_org")"

docker run -ti \
           --rm \
           -v /var/run/docker.sock:/var/run/docker.sock \
           nholuongut/github-actions-runner \
           --url "https://github.com/$repo_or_org" \
           --token "$token" \
           --unattended "$@"
