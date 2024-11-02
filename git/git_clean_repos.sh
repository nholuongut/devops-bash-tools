#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run(){
    local repofile="$1"
    echo "processing repos from file: $repofile"
    sed 's/#.*//; s/:/ /; /^[[:space:]]*$/d' < "$repofile" |
    while read -r _ dir; do
        #if ! echo "$repo" | grep -q "/"; then
        #    repo="nholuongut/$repo"
        #fi
        if [ -d "$dir" ]; then
            pushd "$dir"
            # make update does git pull but if that mechanism is broken then this first git pull will allow the repo to self-fix itself
            if grep -q '^clean:' Makefile; then
                make clean
            fi
            popd
        fi
    done
}

if [ $# -gt 0 ]; then
    for x in "$@"; do
        run "$x"
    done
else
    run "$srcdir/../setup/repos.txt"
fi
