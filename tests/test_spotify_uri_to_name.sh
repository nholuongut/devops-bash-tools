#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Requires $SPOTIFY_USER, $SPOTIFY_ID and $SPOTIFY_SECRET environment variables to run

cd "$srcdir/.."

URIs="
spotify:track:xxxx
https://open.spotify.com/track/xxxxx

spotify:artist:1J2VVASYAamtQ3Bt8wGgA6
https://open.spotify.com/artist/xxxxx

spotify:album:xxxxx
https://open.spotify.com/album/xxxxxx
"

for uri in $URIs; do
    ./spotify_uri_to_name.sh <<< "$uri"
    echo
    SPOTIFY_CSV=1 ./spotify_uri_to_name.sh <<< "$uri"
    echo
done

SPOTIFY_CSV=1 ./spotify_uri_to_name.sh < "../playlists/spotify/Rocky"
echo

./spotify_uri_to_name.sh "../playlists/spotify/Rocky"
echo

echo "Spotify URI to name tests SUCCEEDED"
