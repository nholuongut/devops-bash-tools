#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Jenkins Credentials in the given credential store and domain

Defaults to the 'system' provider's store and global domain '_'

Tested on Jenkins 2.319 with Credentials plugin 2.5

Uses the adjacent jenkins_api.sh - see there for authentication details


The returned credential IDs are what you should be specifying in your Jenkinsfile pipeline:

    environment {
        MYVAR = credentials('some-id')
    }

See master Jenkinsfile for more examples:

    https://github.com/nholuongut/Jenkins/blob/master/Jenkinsfile
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<store> <domain> <curl_options>]"

help_usage "$@"

store="${1:-system}"
domain="${2:-_}"
shift || :
shift || :

"$srcdir/jenkins_api.sh" "/credentials/store/$store/domain/$domain/api/json?tree=credentials\\[id\\]" "$@" |
jq -r '.credentials[].id' |
sort -f
