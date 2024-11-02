#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et

set -eu #o pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

build_files="$(find "${1:-.}" -name build.gradle)"

if [ -z "$build_files" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "G r a d l e"

start_time="$(start_timer)"

if type -P gradle &>/dev/null; then
    type -P gradle
    gradle --version
    echo
    grep -v '/build/' <<< "$build_files" |
    sort |
    while read -r build_gradle; do
        echo "Validating $build_gradle"
        #gradle -b "$build_gradle" -m clean build || exit $?
        # Gradle 8 doesn't let you specify -b, expects build.gradle
        dir="$(dirname "$build_gradle")"
        cd "$dir"
        #gradle -b "$build_gradle" -m clean build || exit $?
        gradle -m clean build || exit $?
    done
else
    echo "Gradle not found in \$PATH, skipping gradle checks"
fi

time_taken "$start_time"
section2 "All Gradle builds passed dry run checks"
echo
