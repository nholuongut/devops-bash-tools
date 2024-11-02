#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: kubernetes-sigs/kustomize kustomize
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/github.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Returns the latest release name/version for a given 'owner/repo' and release regex filter via the GitHub API

This is because some repos like that of Kustomize (kubernetes-sigs/kustomize) have releases for different components
so the latest release API endpoint is not sufficient for the use case of only returning the latest Kustomize release

If a repo has no releases, gets a 404 error

Requires curl and jq to be installed
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<owner>/<repo>"

help_usage "$@"

check_bin curl
check_bin jq

min_args 2 "$@"

owner_repo="$1"
regex_filter="$2"

if ! is_github_owner_repo "$owner_repo"; then
    die "Invalid owner/repo argument given: $owner_repo"
fi

if [ -n "${GITHUB_TOKEN:-}" ]; then
    "$srcdir/github_api.sh" "/repos/$owner_repo/releases"
else
    curl -sSL --fail "https://api.github.com/repos/$owner_repo/releases"
fi |
jq_debug_pipe_dump |
jq -r "limit(1; .[] | select(.tag_name | test(\"$regex_filter\")) | .tag_name)"
