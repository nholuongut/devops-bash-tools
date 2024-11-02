#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
# 
# https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-tracks/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/spotify.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Returns the current Spotify user's Liked Songs (aka Saved Tracks) via the Spotify API

Output format:

Artist - Track

or if \$SPOTIFY_CSV environment variable is set then:

\"Artist\",\"Track\"


$usage_playlist_help

$usage_auth_help
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

# defined in lib/spotify.sh
# shellcheck disable=SC2154
url_path="/v1/me/tracks?limit=$limit&offset=$offset"

output(){
    # some tracks come out with blank artists and track name, skip these using select(name != "") filter to avoid blank lines
    # unfortunately some tracks actually do come out with blank artist and track name, this must be a bug inside Spotify, but
    # filtering it like this throws off the line counts verification and also the track might be blank but the artist might not be
    if not_blank "${SPOTIFY_CSV:-}"; then
        #jq -r '.items[].track | select(.name != "") | [([.artists[].name] | join(", ")), .name] | @csv'
        jq -r '.items[].track | [([.artists[].name] | join(", ")), .name] | @csv'
    else
        #jq -r '.items[].track | select(.name != "") | [([.artists[].name] | join(", ")), "-", .name] | @tsv'
        jq -r '.items[].track | [([.artists[].name] | join(", ")), "-", .name] | @tsv'
    fi <<< "$output" |
    tr '\t' ' ' |
    sed '
        s/^[[:space:]]*-//;
        s/^[[:space:]]*//;
        s/[[:space:]]*$//
    '
}

export SPOTIFY_PRIVATE=1

spotify_token

while not_null "$url_path"; do
    output="$("$srcdir/spotify_api.sh" "$url_path" "$@")"
    #die_if_error_field "$output"
    url_path="$(get_next "$output")"
    output
done
