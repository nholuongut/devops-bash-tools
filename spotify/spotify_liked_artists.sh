#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


# https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-tracks/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/spotify.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Returns the all artist names from tracks in Liked Songs

Useful to see how many tracks are liked from each artist:

    ${0##*/} |

$usage_auth_help
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

# defined in lib/spotify.sh
# shellcheck disable=SC2154
# max 50 artists per request
url_path="/v1/me/tracks?limit=$limit&offset=$offset"

output(){
    #jq -r . <<< "$output"
    jq -r '.items[].track.artists[].name' <<< "$output"
}

export SPOTIFY_PRIVATE=1

spotify_token

while not_null "$url_path"; do
    output="$("$srcdir/spotify_api.sh" "$url_path" "$@")"
    #die_if_error_field "$output"
    url_path="$(get_next "$output")"
    output
done
