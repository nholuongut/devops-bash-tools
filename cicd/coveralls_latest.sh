#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/.bash.d/git.sh"

# shellcheck disable=SC2034
usage_description="
Gets the latest Coveralls.io build info for a given repo

If no repo argument is given, then uses the first GitHub remote from the local git repo

Repo should be qualified with username and is case sensitive

eg.

coveralls_latest.sh nholuongut/pylib
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="user/repo [<curl_options>]"

help_usage "$@"

if [ $# -gt 0 ]; then
    repo="$1"
else
    repo="$(github_user_repo)"
fi

# could add ?page=1 to get the latest 10 builds and their coverage changes
curl -sSL "https://coveralls.io/github/$repo.json" "$@"
# don't pass to jq in case repo doesn't exist you'll get back HTML and a weird
# | jq
