#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/python.sh"

python="${PYTHON:-${python:-python}}"

set +o pipefail
filelist="$(find "${1:-.}" -maxdepth 2 -type f -iname '*.py' -o -iname '*.jy' | grep -v /templates/ | sort)"
set -o pipefail

if [ -z "$filelist" ]; then
    echo "no Python / Jython files found to compile"
    echo
    echo "usage: ${0##*/} <python_file_or_directory>"
    echo
    # shellcheck disable=SC2317
    return 0 &>/dev/null || :
    # shellcheck disable=SC2317
    exit 0
fi

section "Compiling Python / Jython files"

if ! type -P "$python" &>/dev/null; then
    echo "$python not found in \$PATH, skipping compile"
    exit 0
fi

start_time="$(start_timer)"

# opts:
#
# -O  - optimize
# -3  - warn on Python 3 incompatibilies that 2to3 cannot easily fix
# -t  - warn on inconsistent use of tabs

opts=()

if "$python" -V 2>&1 | grep -q 'Python 2'; then
    opts+=(-3)
fi

if ! is_travis &&
   ! type -P pypy &>/dev/null &&
   ! type -P python | grep -qi pypy; then
       opts+=(-t)
fi

if [ -n "${NOCOMPILE:-}" ]; then
    echo "\$NOCOMPILE environment variable set, skipping python compile"
elif [ -n "${QUICK:-}" ]; then
    echo "\$QUICK environment variable set, skipping python compile"
else
    if [ -n "${FAST:-}" ]; then
        # want opt expansion
        # shellcheck disable=SC2086
        "$python" ${opts:+"${opts[@]}"} -m compileall "${1:-.}" || :
    else
        for x in $filelist; do
            type isExcluded &>/dev/null && isExcluded "$x" && continue
            echo "compiling $x"
            # want opt expansion
            # shellcheck disable=SC2086
            "$python" -O ${opts:+"${opts[@]}"} -m py_compile "$x"
        done
    fi
fi

time_taken "$start_time"
section2 "Finished compiling Python / Jython files"
echo
