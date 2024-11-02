#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# fetch Wercker repo details - needed for getting Wercker CI build IDs (eg. for shields.io)

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage(){
    echo "${0##*/} <user>/<application>"
    exit 3
}

if [ $# -ne 1 ]; then
    usage
fi

"$srcdir/wercker_api_app.sh" "$@" |
jq -r '.id'
