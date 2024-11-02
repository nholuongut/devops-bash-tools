#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
. "$srcdir/utils.sh"

# used in client scripts
# shellcheck disable=SC2034
mp3_usage_behaviour_msg="If no directory arguments are given, works on MP3s under \$PWD

Only proposes MP3 files within direct subdirectories to reduce the chance of accidentally running on an entire top level MP3 archive

Shows the list of MP3 files that would be affected before running the metadata update and prompts for confirmation before proceeding for safety"

get_mp3_files(){
    local mp3_files
    mp3_files="$(
        for dir in "$@"; do
            find "$dir" -maxdepth 2 -iname '*.mp3'
        done
    )"
    if is_blank "$mp3_files"; then
        echo "No MP3 files found" >&2
        exit 1
    fi
    echo "$mp3_files"
}
