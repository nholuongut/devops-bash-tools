#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et


# This really only checks basic syntax, if you're made command errors this won't catch it

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

if [ $# -eq 0 ]; then
    if [ -z "$(find "${1:-.}" -type f -iname '*.sh')" ]; then
        return 0 &>/dev/null || :
        exit 0
    fi
fi

section "ShellCheck"

start_time="$(start_timer)"

shellcheck(){
    echo -n "shellcheck: $1 "
    local basename="${1##*/}"
    local dirname
    dirname="$(dirname "$1")"
    # this allows following source hints relative to the source file to be safe to run from any $PWD
    if ! pushd "$dirname" &>/dev/null; then
        echo "ERROR: failed to pushd to $dirname"
        exit 1
    fi
    # -x allows to follow source hints for files not given as arguments
    command shellcheck -x "$basename"
    if ! popd &>/dev/null; then
        echo "ERROR: failed to popd from $dirname"
    fi
    echo "=> OK"
}

recurse_dir(){
    for x in $(find "${1:-.}" -type f -iname '*.sh' | sort); do
        isExcluded "$x" && continue
        [[ "$x" =~ ${EXCLUDED:-} ]] && continue
        shellcheck "$x"
    done
}

if [ $# -gt 0 ]; then
    for x in "$@"; do
        if [ -d "$x" ]; then
            recurse_dir "$x"
        else
            shellcheck "$x"
        fi
    done
else
    recurse_dir .
fi

time_taken "$start_time"
section2 "ShellCheck passed"
echo
