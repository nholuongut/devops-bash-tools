#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# Fetch Wercker App details - needed for getting Wercker CI build IDs (eg. for shields.io)

# https://devcenter.wercker.com/development/api/endpoints/applications/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$srcdir"

usage(){
    echo "${0##*/} <user>/<application_name>"
    exit 3
}

if [ $# -ne 1 ]; then
    usage
fi

for arg; do
    case "$arg" in
        -*) usage
            ;;
    esac
done

application="${1:-}"

if ! [[ "$application" =~ / ]]; then
    application="${GITHUB_USER:-${GIT_USER:-${USER:-}}}/$application"
fi

curl -sS "https://app.wercker.com/api/v3/applications/$application"
