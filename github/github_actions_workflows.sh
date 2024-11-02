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
Returns GitHub Actions Workflows json via the API

If no repo arg is given and is inside a git repo then takes determines the repo from the first git remote listed

Optional workflow id as second parameter will filter to just that workflow

\$REPO and \$WORKFLOW_ID environment variables are also supported with positional args taking precedence
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo> [<workflow_id>]"

help_usage "$@"

repo="${1:-${REPO:-}}"

workflow_id="${2:-${WORKFLOW_ID:-}}"
if [ -n "$workflow_id" ]; then
    workflow_id="/$workflow_id"
fi

if [ -z "$repo" ]; then
    repo="$(git_repo)"
fi

if [ -z "$repo" ]; then
    usage "repo not specified and couldn't determine from git remote command"
fi

for arg; do
    case "$arg" in
        -*)     usage
                ;;
    esac
done

USER="${GITHUB_ORGANIZATION:-${GITHUB_USER:-$(get_github_user)}}"
PASSWORD="${GITHUB_PASSWORD:-${GITHUB_TOKEN:-${PASSWORD:-}}}"

if ! [[ $repo =~ / ]]; then
    repo="$USER/$repo"
fi

# XXX: would need to iterate pages if you have more than 100 workflows
"$srcdir/github_api.sh" "/repos/$repo/actions/workflows$workflow_id?per_page=100" -L # | jq -r '.workflows[].path' | sed 's|.github/workflows/||;s|\.yaml$||'
