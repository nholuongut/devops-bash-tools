#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et


set -eu #o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

config=".concourse.yml"

if [ -z "$(find "${1:-.}" -name "$config")" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "C o n c o u r s e"

start_time="$(start_timer)"

if type -P fly &>/dev/null; then
    type -P fly
    fly --version
    echo
    find "${1:-.}" -name "$config" |
    while read -r config; do
        echo "Validating $config"
        fly validate-pipeline -c "$config" || exit $?
        echo
    done
else
    echo "Concourse 'fly' command not found in \$PATH, skipping concourse config checks"
fi

time_taken "$start_time"
section2 "Concourse config checks passed"
echo
