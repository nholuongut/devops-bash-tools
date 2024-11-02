#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

tld_files="
tlds-alpha-by-domain.txt
custom_tlds.txt
"

section "Checking TLDs for suspect chars"

start_time="$(start_timer)"

files="${*:-}"
if [ -z "$files" ]; then
    for x in $tld_files; do
        files="$files $(find . -iname "$x")"
    done
fi

set +e
for x in $files; do
    #isExcluded "$x" && continue
    echo "checking $x"
    if sed 's/#.*//;/^[[:space:]]$/d;s/[[:alnum:]-]//g' "$x" | grep -o '.'; then
        echo
        echo "ERROR: Invalid chars detected in TLD file $x!! "
    fi
done

time_taken "$start_time"
section2 "Finished checking TLDs for suspect chars"
