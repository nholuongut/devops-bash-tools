#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#

# https://developer.spotify.com/documentation/web-api/reference/follow/get-followed/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/spotify.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Returns the current Spotify user's Followed Artists via the Spotify API

$usage_auth_help
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

# defined in lib/spotify.sh
# shellcheck disable=SC2154
url_path="/v1/me/following?type=artist&offset=$offset&limit=$limit"

output(){
    jq -r '.artists.items[] | select(.name != "") | .name' <<< "$output" |
    sed '
        s/^[[:space:]]*//;
        s/[[:space:]]*$//
    '
}

export SPOTIFY_PRIVATE=1

spotify_token

while not_null "$url_path"; do
    output="$("$srcdir/spotify_api.sh" "$url_path" "$@")"
    #die_if_error_field "$output"
    url_path="$(jq -r '.artists.next' <<< "$output")"
    output
done
