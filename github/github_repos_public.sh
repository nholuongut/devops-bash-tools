#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/github.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists a GitHub user or organization's public repositories using the GitHub API

Useful to periodically scan for any accidentally public repos

\$GITHUB_ORGANIZATION takes precedence over \$GITHUB_USER

See github_api.sh for further authentication details

See also:

    github_repo_teams.sh - to list groups and permissions to each repo (combine with github_foreach_repo.sh to audit all repos)

"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#min_args 1 "$@"

user="${GITHUB_USER:-$(get_github_user)}"
user_or_org="${GITHUB_ORGANIZATION:-$user}"

get_github_repos "$user_or_org" "${GITHUB_ORGANIZATION:-}" "select(.private != true)"
