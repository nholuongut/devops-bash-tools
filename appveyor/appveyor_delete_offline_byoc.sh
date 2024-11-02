#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# eg. nholuongut
if [ -z "${APPVEYOR_ACCOUNT:-}" ]; then
    echo "\$APPVEYOR_ACCOUNT not defined"
    exit 1
fi

echo "Querying AppVeyor for offline BYOC"
"$srcdir/appveyor_api.sh" "account/$APPVEYOR_ACCOUNT/build-clouds" |
jq -r '.[] | select(.status == "Offline") | [.name, .buildCloudId] | @tsv' |
while read -r name id; do
    echo "Deleting offline BYOC '$name'"
    # obtained from the Network debug tab of making UI calls
    "$srcdir/appveyor_api.sh" "account/$APPVEYOR_ACCOUNT/build-clouds/$id" -X DELETE
done
