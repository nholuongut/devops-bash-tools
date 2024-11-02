#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Wercker CLI
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

export PATH="$PATH:$HOME/bin"

help_usage "$@"

export RUN_VERSION_ARG=1

"$srcdir/../packages/install_binary.sh" "https://s3.amazonaws.com/downloads.wercker.com/cli/stable/{os}_{arch}/wercker"
