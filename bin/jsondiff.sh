#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Diffs 2 JSON files given as arguments

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

usage(){
    echo "usage: ${0##*/} file1.json file2.json"
    exit 3
}

if ! [ $# -eq 2 ]; then
    usage
fi

for arg; do
    case "$arg" in
        -*) usage
            ;;
    esac
done

diff <(jq -S . "$1") <(jq -S . "$2")
