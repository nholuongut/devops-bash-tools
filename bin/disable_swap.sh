#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Disables Swap on Linux

Designed to be called modularly from other provisioners to reuse code between scripts

eg. Vagrant provisioners that differ by OS / setup can call this from /github/bash-tools/disable_swap.sh within their scripts

"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

os="$(uname -s)"

if [ "$os" != Linux ]; then
    echo "OS '$os' != Linux, aborting disabling swap"
    exit 1
fi

#echo 0 > /proc/sys/vm/swappiness

timestamp "Disabling All Swap"
swapoff -a

timestamp "Commenting out any Swap lines in /etc/fstab"
sed -i 's,\(/.*[[:space:]]none[[:space:]]*swap[[:space:]]\),#\1,' /etc/fstab

timestamp "Swap disabled"
