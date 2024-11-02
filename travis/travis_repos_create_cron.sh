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
Add a cron job to all Travis CI repos using the Travis CI API

Since you can only have 1 cronjob per branch per repo, this overwrites any existing crons

Args:

branch              - defaults to 'master'
interval            - defaults to 'monthly'. Options: daily, weekly, monthly
recent_dont_rerun   - boolean, defaults to 'true'. Don't run cron job if a build has occurred in the last 24 hours. Set to 0 or 'false' to disable this, any other value is taken as 'true'

Uses the adjacent travis_api.sh script
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<branch>] [<interval>] [<recent_dont_rerun>] [<curl_options>]"

help_usage "$@"

branch="${1:-master}"
interval="${2:-monthly}"
recent_dont_rerun="${3:-true}"
shift || :
shift || :
shift || :

export NO_HEADING=1

"$srcdir/travis_foreach_repo.sh" "'$srcdir/travis_repo_create_cron.sh' '{repo}' '$branch' '$interval' '$recent_dont_rerun'"
