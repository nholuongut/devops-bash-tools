#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
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
Triggers a build for the given Travis CI repo

If no repo is given, then tries to determine the repo name from the local git remote url

If the repo doesn't have a user / organization prefix, then queries
the Travis CI API for the currently authenticated username first

Uses the adjacent travis_*.sh scripts
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<user>/]<repo> [<curl_options>]"

help_usage "$@"

#min_args 1 "$@"

repo="${1:-}"
shift || :

if [ -z "$repo" ]; then
    repo="$(git_repo)"
fi

timestamp "Triggering Travis CI build for repo '$repo'"

repo="$(travis_prefix_encode_repo "$repo")"

"$srcdir/travis_api.sh" "/repo/$repo/requests" -X POST "$@"
