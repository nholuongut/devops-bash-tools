#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et

set -eu #o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

build_files="$(find "${1:-.}" -name build.sbt)"

if [ -z "$build_files" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "S B T"

start_time="$(start_timer)"

if type -P sbt &>/dev/null; then
    type -P sbt
    sbt --version
    echo
    grep -v '/target/' <<< "$build_files" |
    sort |
    while read -r build_sbt; do
        pushd "$(dirname "$build_sbt")" >/dev/null
        echo "Validating $build_sbt"
        echo q | sbt reload || exit $?
        popd >/dev/null
        echo
    done
else
    echo "SBT not found in \$PATH, skipping maven pom checks"
fi

time_taken "$start_time"
section2 "SBT checks passed"
echo
