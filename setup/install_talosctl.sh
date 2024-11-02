#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# https://www.talos.dev/v1.3/introduction/quickstart/

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Talos 'talosctl' client binary
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

curl -sSL https://talos.dev/install | sh
