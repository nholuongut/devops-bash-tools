#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/spotify.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Deletes any duplicates by either URI or 'Artist - Track' name

This is a heavy option that will blast duplicate URIs and then also look for duplicate track name matches
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<playlist_name_or_id>"

help_usage "$@"

min_args 1 "$@"

export SPOTIFY_PRIVATE=1

spotify_token

timestamp "calling spotify_delete_duplicates_in_playlist.sh:"
"$srcdir/spotify_delete_duplicates_in_playlist.sh" "$@"
echo >&2
timestamp "calling spotify_delete_tracks_duplicates_in_playlist.sh:"
"$srcdir/spotify_delete_duplicate_tracks_in_playlists.sh" "$@"
