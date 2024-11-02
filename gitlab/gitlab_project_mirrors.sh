#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists GitLab projects (repos) and whether or not they are mirrors
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

if [ -n "${GITLAB_USER:-}" ]; then
    user="$GITLAB_USER"
else
    # get currently authenticated user
    user="$("$srcdir/gitlab_api.sh" /user | jq -r .username)"
fi

{
    page=1
    while true; do
        if ! output="$("$srcdir/gitlab_api.sh" "/users/$user/projects?page=$page&per_page=100")"; then
            echo "ERROR" >&2
            exit 1
        fi
        if [ -z "$(jq '.[]' <<< "$output")" ]; then
            break
        elif jq -r '.message' <<< "$output" >&2 2>/dev/null; then
            exit 1
        fi
        jq -r '.[] | [.path, if has("mirror") then .mirror else false end ] | @tsv' <<< "$output"
        ((page+=1))
    done
} | column -t
