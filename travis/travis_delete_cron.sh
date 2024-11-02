#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Deletes a given Travis CI cron by ID

See travis_repo_crons.sh which outputs the IDs are the first field

Uses the adjacent travis_api.sh script
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<cron_id>"

help_usage "$@"

min_args 1 "$@"

cron_id="$1"

url_path="/cron/$cron_id"

timestamp "Deleting Travis CI cron job '$cron_id'"
"$srcdir/travis_api.sh" "$url_path" -X DELETE
