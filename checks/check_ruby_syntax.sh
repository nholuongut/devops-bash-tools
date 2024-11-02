#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et
\

set -eu
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

if [ -z "$(find "${1:-.}" -maxdepth 2 -type f -iname '*.pl' -o -iname '*.pm' -o -iname '*.t')" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "Ruby Syntax Checks"

start_time="$(start_timer)"

if type -P ruby &>/dev/null; then
    type -P ruby
    ruby --version
    echo
    for x in $(find "${1:-.}" -maxdepth 2 -type f -iname '*.rb' | sort); do
        isExcluded "$x" && continue
        echo -n "$x: "
        ruby -c "$x"
    done
    time_taken "$start_time"
    section2 "All Ruby programs passed syntax check"
else
    echo "WARNING: ruby not found in \$PATH, skipping ruby syntax checks"
    echo
fi
echo
