#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  args: "Upbeat & Sexual Pop"
#  args: 64OO67Be8wOXn6STqHxexr
#
#

# https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlist/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC2154
. "$srcdir/lib/spotify.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Returns track names in a given Spotify playlist

Playlist argument can be a playlist name or a playlist ID (get this from spotify_playlists.sh)

\$SPOTIFY_PLAYLIST can be used from environment if no first argument is given


Output format:

URI \\t Artist - Track


$usage_playlist_help

$usage_auth_help
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<playlist> [<curl_options>]"

help_usage "$@"

playlist_id="${1:-${SPOTIFY_PLAYLIST:-}}"

shift || :

if is_blank "$playlist_id"; then
    usage "playlist not defined"
fi

spotify_token

playlist_id="$("$srcdir/spotify_playlist_name_to_id.sh" "$playlist_id" "$@")"

# defined in lib/spotify.sh
# shellcheck disable=SC2154
url_path="/v1/playlists/$playlist_id/tracks?limit=100&offset=$offset"

output(){
    jq -r '.items[].track | [.uri, ([.artists[]?.name] | join(", ")), "-", .name] | @tsv' <<< "$output" |
    sed $'s/\t/|/' |
    tr '\t' ' ' |
    tr '|' '\t' |
    sed '
        s/^[[:space:]]*-//;
        s/^[[:space:]]*//;
        s/[[:space:]]*$//
    '
}

while not_null "$url_path"; do
    output="$("$srcdir/spotify_api.sh" "$url_path" "$@")"
    #die_if_error_field "$output"
    url_path="$(get_next "$output")"
    output
done
