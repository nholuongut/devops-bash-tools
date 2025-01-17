#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/git.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Queries the Quay.com API

Requires \$QUAY_TOKEN to be set in the environment

Can specify \$CURL_OPTS for options to pass to curl or provide them as arguments


Set up your OAuth2 access token here:

    https://quay.io/user/<username>?tab=robots


API Reference:

    https://docs.quay.io/api/


API Explorer:

    https://docs.quay.io/api/swagger/
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="/path [<curl_options>]"

url_base="https://quay.io/api/v1"

help_usage "$@"

min_args 1 "$@"

check_env_defined "QUAY_TOKEN"

export TOKEN="$QUAY_TOKEN"

curl_api_opts "$@"

url_path="$1"
shift || :

url_path="${url_path//https:\/\/quay.io\/api\/v1/}"
url_path="${url_path##/}"

"$srcdir/../bin/curl_auth.sh" -L "$url_base/$url_path" "${CURL_OPTS[@]}" "$@"
