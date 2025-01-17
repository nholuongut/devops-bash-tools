#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/mp3.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Adds / Modifies album metadata across all MP3 files in the given directories to group albums or audiobooks for Mac's Books.app

$mp3_usage_behaviour_msg
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="\"album name\" [<dir1> <dir2> ...]"

help_usage "$@"

min_args 1 "$@"

check_bin id3v2

album="$1"

shift || :

# used to pipe file list inline which is more comp sci 101 correct but that could create a race condition on second
# evaluation of file list changing after confirmation prompt, and RAM is cheap, so better to use a static list of files
# stored in ram and operate on that since it'll never be that huge anyway

mp3_files="$(get_mp3_files "${@:-$PWD}")"

echo "List of MP3 files to set album = '$album':"
echo
echo "$mp3_files"
echo

read -r -p "Are you happy to set the album metadata on all of the above mp3 files to '$album'? (y/N) " answer

check_yes "$answer"

echo

while read -r mp3; do
    echo "setting album '$album' on '$mp3'"
    id3v2 --album "$album" "$mp3"
done <<< "$mp3_files"
