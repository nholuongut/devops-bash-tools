#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  args: < <(find ../playlists/spotify/ -type f)
#
# 
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Normalizes a Spotify playlist filename provided as arg(s) or stdin to an original playlist name

This is used because playlists with slashes have them converted to unicode equivalent by spotify_playlist_to_filename.sh, so when searching for playlists in spotify_playlist_name_to_id.sh, I use this script to reverse the process to allow for using auto-completed filenames as playlist names and still having everything resolve correctly
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<playlist_filename>"

help_usage "$@"

normalize(){
    # strip folder name
    sed 's,.*/,,' |
    # replace unicode forward slash needed for storing as filename with the original ascii version in the real playlist name
    tr '∕' '/'
}

if not_blank "$*"; then
    normalize <<< "$*"
else
    normalize  # from stdin
fi
