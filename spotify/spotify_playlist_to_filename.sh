#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  args: < ../playlists/playlists.txt
#
# 

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Normalizes a Spotify playlist name provided as arg(s) or stdin to a valid filename
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<playlist_name>"

help_usage "$@"

normalize(){
    # replace forward slash with unicode version so we can store playlist files that look like the real thing
    # but avoid the breakage caused by directory separator
    tr '/' '∕'
    #tr '/[:space:]' '_'
    # requires Perl 5.10+
    #perl -pe 's/[\h\/]/_/g'
    #perl -pe 's/!//g'
    #perl -pe 's/[^\w\v-]/_/g'
}

if not_blank "$*"; then
    normalize <<< "$*"
else
    normalize  # from stdin
fi
