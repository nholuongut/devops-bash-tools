#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -eu #o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

config="codefresh.yml"

files="$(find "${1:-.}" -name "$config")"

if [ -z "$files" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "C o d e f r e s h"

start_time="$(start_timer)"

if type -P codefresh &>/dev/null; then
    type -P codefresh
    codefresh version
    echo
    if [ -n "${CODEFRESH_KEY:-}" ]; then
        while read -r config; do
            echo "Validating $config"
            codefresh validate "$config" || exit $?
            echo
        done <<< "$files"
        time_taken "$start_time"
        section2 "Codefresh config checks passed"
    else
        echo "\$CODEFRESH_KEY not found in environment, can't validate without API authentication, skipping codefresh config checks"
    fi
else
    echo "Codefresh command not found in \$PATH, skipping codefresh config checks"
fi

echo
