#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$srcdir"

if [ -n "$*" ]; then
    echo "$@"
else
    sed 's/#.*//; s/:/ /' "$srcdir/../setup/repos.txt"
fi |
grep -vi -e bash-tools \
         -e playlist \
         -e '^[[:space:]]*$' |
while read -r repo dir; do
    if [ -z "$dir" ]; then
        dir="$repo"
    fi
    repo="$(tr '[:upper:]' '[:lower:]' <<< "$repo")"
    if ! [ -d "../$dir" ]; then
        echo "WARNING: repo dir $dir not found, skipping..."
        continue
    fi
    sed 's/#.*//; /^[[:space:]]*$/d' "$srcdir/../setup/repo-configs.txt" |
    while read -r filename; do
        target="../$dir/$filename"
        if [ -f "$target" ] || [ -n "${NEW:-}" ]; then
            :
        else
            continue
        fi
        mkdir -pv "${target%/*}"
        echo "syncing $filename -> $target"
        perl -pe "s/(devops-)*bash-tools/$repo/i" "$filename" > "$target"
    done
done
