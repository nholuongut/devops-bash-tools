#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

trap 'echo ERROR >&2' exit

cd "$srcdir"

file="STATUS.md"

echo
echo "Generating STATUS.md"
echo
{
"$srcdir/../github/github_generate_status_page.sh"
echo
echo "---"
echo
#"$srcdir/../docker/docker_generate_status_page.sh"
echo
echo https://git.io/nholuongut-ci
} | tee "$file"

echo
echo
echo "Generating STARCHARTS.md"
echo
"$srcdir/../github/github_generate_starcharts.md.sh"

trap '' exit
