#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
#. "$srcdir/lib/utils.sh"

if [ -z "${SHIPPABLE_TOKEN:-}" ]; then
    echo "Shippable token not set, skipping shippable check"
    exit 0
fi
echo "Checking Shippable README.md Project Badge"
# https://img.shields.io/shippable/5e52c634d79b7d00077bf5ed/master?label=Shippable)](https://app.shippable.com/github/nholuongut/DevOps-Bash-tools/dashboard/jobs
find . -name README.md -exec grep -Eo 'img.shields.io/shippable/.*app.shippable.com/[^/]+/[^/]+/[^/]+' {} \; |
sed 's,img.shields.io/shippable/,,; s,[^[:alnum:]].*app.shippable.com/[^/]*/, ,' |
while read -r id name; do
    "$srcdir/../shippable/shippable_projects.sh" "$id" "$@" |
    while read -r id2 owner repo; do
        if [ "$id" != "$id2" ]; then
            echo "id '$id' != returned id '$id2'"
            exit 1
        fi
        if [ "${name}" != "$owner/$repo" ]; then
            echo "README.md Shippable badge name '$name' vs ID mismatch ('$owner/$repo')"
            exit 1
        fi
    done || exit 1
done
echo
