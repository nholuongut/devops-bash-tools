#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -eu
[ -n "${DEBUG:-}" ] && set -x


if [ -z "$*" ]; then
    echo "usage: ${0##*/} arg1 arg2 arg3 ..."
    exit 1
fi

i=0
for x in "$@"; do
    a[$i]="$x"
    ((i + 1))
done

num=${#@}

selected=$((RANDOM % num))

echo "${a[$selected]}"
