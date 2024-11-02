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
Shows the settings for all Travis CI repos in TSV format

Output format:

<repo_name>     <setting_name>      <setting_value>

Handy way of checking your settings are consistent across repos.

To compare each setting side by side, consider this command:

    travis_repos_settings.sh | column -t | sort -k3

Uses the adjacent travis_*.sh scripts
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

export NO_HEADING=1

"$srcdir/travis_foreach_repo.sh" "'$srcdir/travis_repo_settings.sh' '{repo}' | perl -pn -e 's/^/{name}\\t/'"
