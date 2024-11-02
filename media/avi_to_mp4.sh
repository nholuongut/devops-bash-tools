#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Converts one or more AVI files given or found recursively under given paths or current directory to mp4 format using ffmpeg

Useful to be able to stream videos to devices like smart TVs that may otherwise not understand the codecs used in the original format

Names the generated files the same except with the '.avi' extension replaced with '.mp4'

Skips files which already have a corresponding adjacent '.mp4' file present to be able to resume partial directory conversions, and also removes partially complete files for consistency using bash trapping
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<files_or_directories>]"

help_usage "$@"

#min_args 1 "$@"

check_bin ffmpeg

SECONDS=0

time \
for basedir in "${@:-.}"; do
    while read -r filepath; do
        mp4_filepath="${filepath%.avi}.mp4"
        if ! [ -s "$mp4_filepath" ]; then
            trap_cmd "echo; echo 'removing partially done file:'; rm -fv '$mp4_filepath'; untrap"
            timestamp "converting $filepath => $mp4_filepath"
            #time nice ffmpeg -i "$filepath" "$mp4_filepath" < /dev/null  # don't let the ffmpeg command eat the incoming filenames
            time nice ffmpeg -i "$filepath" -vcodec copy -acodec copy -scodec mov_text -movflags +faststart "$mp4_filepath" < /dev/null
            echo
        fi
    done < <(find "$basedir" -type f -iname '*.avi')
done

echo
echo "All conversions completed in $SECONDS secs"
untrap
