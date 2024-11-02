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
Follows all artists in your Spotify top artists list using the Spotify API

Useful to ensure that you are following the artists you most listen to
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"
no_more_opts "$@"

export SPOTIFY_PRIVATE=1

spotify_token

"$srcdir/spotify_top_artists_uri.sh" |
"$srcdir/spotify_follow_artists.sh"
