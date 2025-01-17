#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# Script to diff settings changes and then drop in to the new settings json to explore
#
# Speeds up experimentation and key collecting for adjacent script mac_settings.sh

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

dir="$srcdir/mac_settings"

mkdir -pv "$dir"

before_settings="$dir/settings-before-$(date '+%F_%H%M%S').json"

defaults read > "$before_settings"

echo "Settings Saved"
echo
echo "Now make your changes"
echo
echo "Press Enter when ready to collect the changes difference"

read -r

after_settings="$dir/settings-after-$(date '+%F_%H%M%S').json"

defaults read > "$after_settings"

diff "$before_settings" "$after_settings" | less -+F -i || :

exec "${EDITOR:-vim}" "$after_settings"
