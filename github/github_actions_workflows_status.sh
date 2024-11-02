#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists GitHub Actions Workflows run status via the API

If no repo arg is given and is inside a git repo then takes determines the repo from the first git remote listed

\$REPO and \$WORKFLOW_ID environment variables are also supported with positional args taking precedence
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo> [<workflow_id>]"

help_usage "$@"

workflows="$(
    "$srcdir/github_actions_workflows.sh" "$@" |
    jq -r '.workflows[].path' |
    sed 's|.github/workflows/||;s|\.yaml$||'
)"


for workflow_name in $workflows; do
    {
    output="$(
        printf '%s\t' "$workflow_name"
        "$srcdir/github_actions_workflow_runs.sh" "$workflow_name" |
        jq -r 'limit(1; .workflow_runs[] | select(.status == "completed") | .conclusion)'
    )"
    echo "$output"
    } &
done |
sort |
column -t
