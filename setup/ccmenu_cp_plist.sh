#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

plist_dir="Library/Containers/net.sourceforge.cruisecontrol.CCMenu/Data/Library/Preferences"

plist_file="net.sourceforge.cruisecontrol.CCMenu.plist"

cd "$srcdir/.."

cp -vf -- ~/"$plist_dir/$plist_file" "$PWD/$plist_dir/$plist_file"
plutil -convert xml1 "$PWD/$plist_dir/$plist_file"
echo

echo "git diff $PWD/$plist_dir/$plist_file"
git diff "$PWD/$plist_dir/$plist_file"
