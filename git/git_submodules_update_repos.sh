#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git_url="${GIT_URL:-https://github.com}"

git_base_dir=~/github

mkdir -pv "$git_base_dir"

cd "$git_base_dir"

repofile="$srcdir/../setup/repos.txt"

if [ $# -gt 0 ]; then
    repolist="$*"
else
    repolist="${*:-${REPOS:-}}"
    if [ -n "$repolist" ]; then
        :
    elif [ -f "$repofile" ]; then
        echo "processing repos from file: $repofile"
        repolist="$(sed 's/#.*//; /^[[:space:]]*$/d' < "$repofile")"
    else
        echo "fetching repos from GitHub repo list"
        repolist="$(curl -sSL https://raw.githubusercontent.com/nholuongut/bash-tools/master/setup/repos.txt | sed 's/#.*//')"
    fi
fi

run(){
    local repolist="$*"
    echo "Updating Git submodules"
    echo
    for repo in $repolist; do
        repo_dir="${repo##*/}"
        repo_dir="${repo_dir##*:}"
        repo="${repo%%:*}"
        if ! echo "$repo" | grep -q "/"; then
            repo="nholuongut/$repo"
        fi
        echo "========================================"
        echo "Updating $repo"
        echo "========================================"
        if ! [ -d "$repo_dir" ]; then
            git clone "$git_url/$repo" "$repo_dir"
        fi
        pushd "$repo_dir"
        # make update does git pull but if that mechanism is broken then this first git pull will allow the repo to self-fix itself
        git pull --no-edit
        git submodule update --init --remote --recursive
        for submodule in $(git submodule | awk '{print $2}'); do
            echo
            echo "committing latest hashref for submodule $submodule"
            git ci -m "updated submodule $submodule" "$submodule" || :
        done
        echo
        [ -n "${NO_PUSH:-}" ] || git push
        popd
        echo
    done
}

run "$repolist"
