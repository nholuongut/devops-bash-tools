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
Re-runs the last failed run of each workflow for the current or given GitHub repo

Requires GitHub CLI to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<owner>/<repo>]"

help_usage "$@"

#min_args 1 "$@"

owner_repo="${1:-}"

args=()
if [ -n "$owner_repo" ]; then
    is_github_owner_repo "$owner_repo" || die "Invalid GitHub owner/repo given: $owner_repo"
    args+=(-R "$owner_repo")
fi

gh run list -L 200 ${args:+"${args[@]}"} \
            --json name,status,conclusion,workflowDatabaseId,databaseId \
            -q '.[] |
                select(.status == "completed") |
                select(.conclusion != "success") |
                select(.conclusion != "skipped") |
                [.databaseId, .name] |
                @tsv' |
sort -u -k 2,3 |
while read -r id name; do
    timestamp "re-triggering workflow run: $name ($id)"
    echo "gh run rerun ${args:+"${args[*]}"} $id"
done |
parallel -j 5
