#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Recurses a given directory tree or \$PWD, finding all Java files and validating them using 'javac'

Probably overly simplistic for a Java project, check a real linter instead
"

help_usage "$@"

directory="${1:-.}"
shift ||:

filelist="$(find "$directory" -type f -iname '*.java' | sort)"
if [ -z "$filelist" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "J a v a"

start_time="$(start_timer)"

if type -P javac &>/dev/null; then
    type -P javac
    javac -version
    echo
    while read -r filename; do
        isExcluded "$filename" && continue
        echo "javac $filename $*"
        javac "$filename" "$@"
    done <<< "$filelist"
else
    echo "WARNING: javac not found in \$PATH, skipping Java checks"
    exit 0
fi

echo
time_taken "$start_time"
section2 "Java checks passed"
echo
