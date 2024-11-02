#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Overwrites a given file using dd to prevent recovery of sensitive information

WARNING: you should only do this on old HDD, not SSD, hard drives which have a limited number of writes - you may shorten an SSD's lifespan if you over use this

Use this only if you've accidentally written some credential / sensitive data to disk and then already deleted it, leaving the file data on disk
without a filename to inode pointer to overwrite just the file

This prevents file recovery tools from stealing your sensitive data, credentials etc. because otherwise
the file data is still there on disk without a filename inode pointer and file recovery tools may be able to recover and steal it

Your disk should also be encrypted anyway for security best practices, in which case you shouldn't need to do this

Works by writing random data into a large file in the \$PWD until the disk is full and then deletes the file. This is an old trick from the 2000s

See also:

On Mac:

    rm -P   overwrites file 3 times before deleting it (-P switch is available on BSD 'rm' variant only)

on Linux:

    srm     from secure-delete package
    shred
    wipe

    sfill   works similar to this script except does 2 overwrites - DoD secure standard is 7 overwrites

    sswap   overwrites your swap device

    sdmem   overwrites your RAM to prevent warm boot attacks retrieving sensitive credentials or data
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=" [<filename> <passes>]"

help_usage "$@"

max_args 2 "$@"

file="${1:-.}"
passes="${2:-7}"

if ! [ -f "$file" ]; then
    die "File '$file' does not exit"
fi

filesize="$(du "$file" | awk '{print $1}')"

timestamp "Overwriting file '$file'"
for (( i = 0; i < passes; i++ )); do
    timestamp "overwrite pass 1..."
    dd bs="$filesize" count=1 if=/dev/urandom of="$file"
done

timestamp "Removing file:"
rm -fv "$file"
