#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

repofile="$srcdir/../setup/repos.txt"

if [ -f "$repofile" ]; then
    echo "processing repos from local file: $repofile" >&2
    cat "$repofile"
else
    echo "fetching repos from GitHub repos.txt:" >&2
    curl -sSL https://raw.githubusercontent.com/nholuongut/bash-tools/master/setup/repos.txt
fi |
sed 's/#.*//; s/.*://; /^[[:space:]]*$/d'
