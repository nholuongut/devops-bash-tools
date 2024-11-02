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
Lists GitHub Actions Workflows enabled/disable state via the API

Output format:

<workflow_id>    <enabled/disable>   <workflow_name>


To scan all repos to find any disabled workflows, such as developers disabling code scanning workflows that are bugging them in PRs, do:

    github_foreach_repo.sh github_actions_workflows_disabled.sh {owner}/{repo}
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo> [<workflow_id>]"

help_usage "$@"

"$srcdir/github_actions_workflows.sh" "$@" |
jq -r '.workflows[] | select(.state != "active") | [.id, .state, .name ] | @tsv'
