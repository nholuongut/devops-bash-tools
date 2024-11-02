#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Checks for broken script references in scripts in the current or given directories, where they are referenced via \$srcdir/scriptname.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<dirs_to_check>]"

help_usage "$@"

for x in "${@:-.}"; do
    pushd "$x" &>/dev/null
    for script in $(git grep --max-depth 0 '^[^#]*srcdir/[[:alnum:]_]*.sh' -- . |
                    grep -v "${0##*/}:.*\\\$srcdir/scriptname.sh" |
                    grep -Eo 'srcdir/[[:alnum:]_/-]*\.sh' |
                    sed 's/srcdir/./g' |
                    sort -u); do
        if ! [ -f "$script" ]; then
            echo "FAILED to find script $script"
            exit 1
        fi
    done
    popd &>/dev/null
done
