#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# Pulls all my Git repos listed in setup/repos.txt to ~/github/ and runs a 'make update' build

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git_url="${GIT_URL:-https://github.com}"

git_base_dir=~/github

mkdir -pv "$git_base_dir"

cd "$git_base_dir"

sed 's/#.*//; s/:/ /; /^[[:digit:]]*$/d' "$srcdir/../setup/repos.txt" |
while read -r repo dir; do
    if [ -z "$dir" ]; then
        dir="$repo"
    fi
    if ! echo "$repo" | grep -q "/"; then
        repo="nholuongut/$repo"
    fi
    if [ -d "$dir" ]; then
        pushd "$dir"
        # make update does git pull but if that mechanism is broken then this first git pull will allow the repo to self-fix itself
        if [ -n "${QUICK:-}" ] ||
           [ -n "${NOBUILD:-}" ] ||
           [ -n "${NO_BUILD:-}" ]; then
            make update-no-recompile || exit 1
        else
            make update
        fi
        popd
    else
        git clone "$git_url/$repo" "$dir"
    fi
done
