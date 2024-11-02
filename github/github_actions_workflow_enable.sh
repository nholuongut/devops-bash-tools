#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Enables a GitHub Actions workflow via the API

Use this to enable a workflow programmatically.
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo> <workflow_id>"

help_usage "$@"

min_args 2 "$@"

repo="$1"
workflow_id="$2"

USER="${GITHUB_ORGANIZATION:-${GITHUB_USER:-$(get_github_user)}}"

if ! [[ $repo =~ / ]]; then
    repo="$USER/$repo"
fi

timestamp "Enabling github actions workflow with id '$workflow_id'"
"$srcdir/github_api.sh" "/repos/$repo/actions/workflows/$workflow_id/enable" -X PUT
timestamp "workflow id '$workflow_id' enabled'"
