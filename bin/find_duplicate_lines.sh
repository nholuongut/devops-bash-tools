#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Script to find duplicate lines across files

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_args="<files>"

for x in "$@"; do
    # shellcheck disable=SC2119
    case "$x" in
    -h|--help)  usage
                ;;
    esac
done

found=0

while read -r line; do
    grep -Fx "$line" "$@"
    ((found + 1))
done < <(
    sed 's/#.*//;
         s/^[[:space:]]*//;
         s/[[:space:]]*$//;
         /^[[:space:]]*$/d;' "$@" |
    sort |
    uniq -d
)

if [ $found -gt 0 ]; then
    exit 1
fi
