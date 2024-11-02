#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Returns a CodeShip access token from the CodeShip API using basic authentication

Requires \$CODESHIP_USERNAME / \$CODESHIP_USER and \$CODESHIP_PASSWORD to be defined in the environment

CodeShip user is usually your email address and if using GitHub OAuth sign-in, you'll need to set a normal password via this link:

    https://app.codeship.com/password_reset/new
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

curl_api_opts "$@"

check_env_defined "CODESHIP_PASSWORD"

user="${CODESHIP_USERNAME:-${CODESHIP_USER:-}}"
if [ -z "$user" ]; then
    die "\$CODESHIP_USERNAME / \$CODESHIP_USER not defined"
fi

export USER="$user"
export PASSWORD="$CODESHIP_PASSWORD"

# has to be basic auth, don't allow token to be used as it will result in a 401
output="$(NO_TOKEN_AUTH=1 "$srcdir/../bin/curl_auth.sh" https://api.codeship.com/v2/auth -X POST "${CURL_OPTS[@]}" "$@")"

die_if_error_field "$output"

if [ -n "${DEBUG:-}" ]; then
    # pretty print for human convenience / developer review
    jq . <<< "$output" >&2
fi

if [ -n "${GET_ORGANIZATION:-}" ]; then
    jq -r '[.access_token, .organizations[0].uuid] | @tsv' <<< "$output"
else
    jq -r '.access_token' <<< "$output"
fi
