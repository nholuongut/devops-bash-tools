#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  

# https://developer.travis-ci.org/resource/caches#Caches

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/travis.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Shows the caches for all Travis CI repos

Output Format;

<repo>    <branch>    <size>    <last_modified>    <long_name>

Uses the adjacent travis_*.sh scripts
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export NO_HEADING=1

"$srcdir/travis_foreach_repo.sh" "'$srcdir/travis_repo_caches.sh' '{repo}'"
