#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

makefiles="$(find "${1:-.}" -maxdepth 2 -name Makefile -o -name Makefile.in)"

if [ -z "$makefiles" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "M a k e"

start_time="$(start_timer)"

if type -P make &>/dev/null; then
    type -P make
    make --version
    echo
    while read -r makefile; do
        pushd "$(dirname "$makefile")" >/dev/null
        echo "Validating $makefile"
        makefile="${makefile##*/}"
        if grep '#@' "$makefile"; then
            echo "WARNING: commented lines still visible in $PWD/$makefile"
        fi
        while read -r target; do
            if [[ "$target" =~ wc-?(code|scripts) ]]; then
                continue
            fi
            if ! make -f "$makefile" --warn-undefined-variables -n "$target" >/dev/null; then
                echo "Makefile validation FAILED"
                exit 1
            fi
        done < <(
            grep '^[[:alnum:]]\+:' "$makefile" |
            sort -u |
            sed 's/:.*$//'
        ) || :  # without this if no targets are found like in Dockerfiles/jython (which is all inherited) and this will fail set -e silently error out and not check the rest of the Makefiles
        popd >/dev/null
    done <<< "$makefiles"
else
    echo "WARNING: 'make' is not installed, skipping..."
    echo
    exit 0
fi

time_taken "$start_time"
section2 "Makefile validation SUCCEEDED"
echo
