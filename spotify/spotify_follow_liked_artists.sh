#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/spotify.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Follows Spotify artists with N or more tracks in your Liked Songs using the Spotify API

The threshold for the number of Liked Songs for an artist to be followed defaults to 5 Liked Songs but this can be overriden using the first argument
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<threshold_number_of_Liked_Songs>"

help_usage "$@"
no_more_opts "$@"

threshold="${1:-5}"

is_int "$threshold" || usage "threshold given is not an integer"

export SPOTIFY_PRIVATE=1

spotify_token

"$srcdir/spotify_liked_artists_uri.sh" |
sort |
uniq -c |
sort -k1nr |
while read -r num uri; do
    if [ "$num" -ge 5 ]; then
        echo "$uri"
    fi
done |
"$srcdir/spotify_follow_artists.sh"
