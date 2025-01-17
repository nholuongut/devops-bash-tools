#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds symlinks which point to non-existent files

See Also:

    checks/check_broken_symlinks.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<dir>]"

help_usage "$@"

max_args 1 "$@"

dir="${1:-.}"

exitcode=0

find "$dir" -type l |
while read -r symlink; do
    target="$(readlink -f "$symlink")"
    if ! [ -e "$target" ]; then
        echo "Symlink broken: $symlink -> $target"
        exitcode=1
    fi
done

exit $exitcode
