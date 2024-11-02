#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  
# Update: using Shpotify now which is installed via adjacent brew packages list

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs SpotifyControl CLI
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

export PATH="$PATH:$HOME/bin"

help_usage "$@"

"$srcdir/../packages/install_binary.sh" "https://raw.githubusercontent.com/dronir/SpotifyControl/master/SpotifyControl"
