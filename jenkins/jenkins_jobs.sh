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
Lists Jenkins Job/Pipeline Names via the Jenkins API

Tested on Jenkins 2.319

Uses the adjacent jenkins_api.sh - see there for authentication details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<store> <domain> <curl_options>]"

help_usage "$@"

"$srcdir/jenkins_api.sh" '/api/json?tree=jobs\[name\]&pretty=true' |
jq -r '.jobs[].name' |
sort -f
