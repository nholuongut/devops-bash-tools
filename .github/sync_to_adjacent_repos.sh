#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#
#  https://github.com/nholuongut/devops-bash-tools
#
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish

#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$srcdir"

if [ $# -eq 0 ];then
    echo "usage: <file1> <file2> ..."
    exit 1
fi

sync_file(){
    local filename="$1"
    local repo="$2"
    local dir="${3:-}"
    if [ -z "$dir" ]; then
        dir="$repo"
    fi
    dir="$(tr '[:upper:]' '[:lower:]' <<< "$dir")"
    if ! [ -d "../../$dir" ]; then
        echo "WARNING: repo dir $dir not found, skipping..."
        return 0
    fi
    target="../../$dir/.github/$filename"
    targetdir="${target%/*}"
    mkdir -p -v "$targetdir"
    echo "syncing $filename -> $target"
    perl -p -e "s/(DevOps-)?Bash-tools/$repo/i" "$filename" > "$target"
}

sed 's/#.*//; s/:/ /' ../setup/repos.txt |
grep -v -e bash-tools \
        -e '^[[:space:]]*$' |
while read -r repo dir; do
    for filename in "$@"; do
        sync_file "$filename" "$repo" "$dir"
    done
done
