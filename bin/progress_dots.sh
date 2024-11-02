#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Quick pipe script to give progress dots on stderr while you pipe or redirect > to a file
#
# eg. some_big_command | progress_dots.sh > file.txt

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

LINES_PER_DOT="${LINES_PER_DOT:-100}"

if ! [[ "$LINES_PER_DOT" =~ ^[[:digit:]]+$ ]]; then
    echo "LINES_PER_DOT must be an integer!" >&2
    exit 1
fi

count=0

if [ $# -gt 0 ]; then
    "$@"
else
    cat
fi |
while read -r line; do
    ((count+=1))
    perl -e "if($count % $LINES_PER_DOT == 0){print STDERR '.'}"
    printf '%s\n' "$line"
done
echo >&2
