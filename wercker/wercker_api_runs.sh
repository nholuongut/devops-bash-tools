#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
# Fetch Wercker App runs by name

# https://devcenter.wercker.com/development/api/endpoints/runs/

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

application_id="$("$srcdir/wercker_app_id.sh" "$application")"

# pipeline id also works but easier to reuse the app id
#
# eg. curl -sS "https://app.wercker.com/api/v3/runs?pipelineId=5e53ee690783f9080047a6ce"
#
curl -sS "https://app.wercker.com/api/v3/runs?applicationId=$application_id"
