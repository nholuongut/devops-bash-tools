#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

filelist="$(find "${1:-.}" -type f -name '*playbook.y*ml' | sort)"

if [ -z "$filelist" ]; then
    return 0 &>/dev/null ||
    exit 0
fi

section "Ansible Syntax Checks"

start_time="$(start_timer)"

if [ -n "${NOSYNTAXCHECK:-}" ]; then
    echo "\$NOSYNTAXCHECK environment variable set, skipping Ansible syntax checks"
    echo
elif [ -n "${QUICK:-}" ]; then
    echo "\$QUICK environment variable set, skipping Ansible syntax checks"
    echo
else
    if ! command -v ansible-lint &>/dev/null; then
        echo "ansible-lint not found in \$PATH, not running Ansible syntax checks"
        return 0 &>/dev/null || exit 0
    fi
    ansible-lint --version
    echo
    max_len=0
    for x in $filelist; do
        if [ ${#x} -gt $max_len ]; then
            max_len=${#x}
        fi
    done
    # to account for the semi colon
    ((max_len + 1))
    for x in $filelist; do
        isExcluded "$x" && continue
        printf "%-${max_len}s " "$x:"
        set +eo pipefail
        output="$(ansible-lint "$x")"
        # shellcheck disable=SC2181
        if [ $? -eq 0 ]; then
            echo "OK"
        else
            echo "FAILED"
            if [ -z "${QUIET:-}" ]; then
                echo
                echo "$output"
                echo
            fi
            if [ -z "${NOEXIT:-}" ]; then
                return 1 &>/dev/null || exit 1
            fi
        fi
        set -eo pipefail
    done
    time_taken "$start_time"
    section2 "All Ansible playbook files passed syntax check"
fi
echo
