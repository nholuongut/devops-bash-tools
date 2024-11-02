#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et


set -eu #o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

poms="$(find "${1:-.}" -name "pom.xml")"

if [ -z "$poms" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "M a v e n"

start_time="$(start_timer)"

opts=()

if is_CI; then
    opts+=(-B)
fi

if type -P mvn &>/dev/null; then
    type -P mvn
    mvn --version
    echo
    grep -v '/target/' <<< "$poms" |
    while read -r pom; do
        echo "Validating $pom"
        mvn validate ${opts:+"${opts[@]}"} -f "$pom" || exit $?
        echo
    done
else
    echo "Maven not found in \$PATH, skipping maven pom checks"
fi

time_taken "$start_time"
section2 "Maven pom checks passed"
echo
