#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Cancels runs waiting for deployment environment approval in the current or given GitHub repo (these can build up from pushes)

Requires GitHub CLI to be installed and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<user>/<repo>]"

check_env_defined "GITHUB_TOKEN"

help_usage "$@"

max_args 1 "$@"

args=()
if [ $# -gt 0 ]; then
    repo="$1"
    args+=(-R "$repo")
fi

gh run list -L 200 ${args:+"${args[@]}"} \
            --json name,status,databaseId \
            -q '.[] | select(.status == "waiting") | [.databaseId, .name] | @tsv' |
while read -r id name; do
    timestamp "Cancelling workflow: $name"
    echo gh run cancel ${args:+"${args[@]}"} "$id"
done |
parallel -j 10
