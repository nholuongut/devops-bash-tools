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
Sets the description summary of a DockerHub.com repo via the DockerHub API

Useful to sync GitHub repo description to DockerHub repo description

Uses the adajcent script dockerhub_api.sh, see there for authentication details

\$CURL_OPTS can be set to provide extra arguments to curl


Example:

    ${0##*/} nholuongut/my-repo    my new description


If no second arg is given, will read repo description from standard input

    echo <description> | ${0##*/} nholuongut/my-repo
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<owner/repo> [<description>]"

help_usage "$@"

min_args 1 "$@"

owner_repo="$1"
description="${*:2}"

if [ $# -lt 2 ]; then
    echo "reading repo summary description from stdin" >&2
    description="$(cat)"
fi

timestamp "Setting DockerHub repo '$owner_repo' description to '$description'"

# don't URL encode this as it's inside JSON
#description="$("$srcdir/../bin/urlencode.sh" <<< "$description")"
# just strip quotes to protect the JSON
description="${description//\"/}"

"$srcdir/dockerhub_api.sh" "/repositories/$owner_repo" -X PATCH --data "{ \"description\": \"$description\" }"
