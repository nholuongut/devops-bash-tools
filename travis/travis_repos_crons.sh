#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/travis.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists all crons for all Travis CI repos using the Travis CI API

Output Format:

<repo>    <id>    <branch>    <interval>    <created_at>    <last_run>    <next_run>


Uses the adjacent travis_api.sh script
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export NO_HEADING=1

"$srcdir/travis_foreach_repo.sh" "'$srcdir/travis_repo_crons.sh' '{repo}' | perl -pn -e 's/^/{name}\\t/'"
