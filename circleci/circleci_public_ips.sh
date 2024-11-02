#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# https://circleci.com/docs/2.0/ip-ranges/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists CircleCI public IP addresses eg. for auto-populating firewall rules

You will also need to enable 'circleci_ip_ranges: true' in your job to use these fixed IPs (requires paid plan):

    https://circleci.com/docs/2.0/configuration-reference/#circleciipranges
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#curl -sSL https://dnsjson.com/all.knownips.circleci.com/A.json |
#jq -r '.results.records[]' |
#sort -n

"$srcdir/../bin/dnsjson.sh" all.knownips.circleci.com
