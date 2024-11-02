#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC2034
usage_description="
Finds duplicate files by file checksum

Only compares files with the same byte counts for efficiency, using the adjacent find_duplicate_files_by_size.sh
as a pre-filter to speed up the process

Output format:

<md5_checksum>      <filename>

For a much more sophisticated duplicate file finder utilizing size, checksums, basenames and
even partial basenames via regex match see

find_duplicate_files.py

in the DevOps Python tools repo:

https://github.com/nholuongut/python-for-devops
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<dir1> <dir2> ...]"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

help_usage "$@"

last_checksum=""
last_filename=""
last_printed=0

# discard size and use checksum as next level filter
# shellcheck disable=SC2034
"$srcdir/find_duplicate_files_by_size.sh" "$@" |
while read -r size filename; do
    md5sum "$filename"  # outputs <checksum> <filename>
done |
sort -k1n |
while read -r checksum filename; do
    if [ "$checksum" = "$last_checksum" ]; then
        if [ "$last_printed" = 0 ]; then
            printf '%s\t%s\n' "$last_checksum" "$last_filename"
        fi
        printf '%s\t%s\n' "$checksum" "$filename"
        last_printed=1
    else
        last_printed=0
    fi
    last_checksum="$checksum"
    last_filename="$filename"
done
