#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -eu
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/python.sh"

# maxdepth 2 to avoid recursing submodules which have their own checks
files="$(find_python_jython_files . -maxdepth 2)"

if [ -z "$files" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "Python - find and alert on any usage of assert outside of /test/"

start_time="$(start_timer)"

found=0
while read -r filename; do
    type isExcluded &>/dev/null && isExcluded "$filename" && echo -n '-' && continue
    # exclude pytests
    [[ "$filename" = ./test/* ]] && continue
    echo -n '.'
    if grep -E '^[[:space:]]+\bassert\b' "$filename"; then
        echo
        echo "WARNING: $filename contains 'assert'!! This could be disabled at runtime by PYTHONOPTIMIZE=1 / -O / -OO and should not be used!! "
        found=1
        #if ! is_CI; then
        #    exit 1
        #fi
    fi
done <<< "$files"

time_taken "$start_time"

if [ -n "${WARN_ONLY:-}" ]; then
    section2 "Python OK - assertions scan finished"
else
    if [ $found != 0 ]; then
        exit 1
    fi
    section2 "Python OK - no assertions found in normal code"
fi

echo
