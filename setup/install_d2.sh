#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs the D2 diagram scripting language

    https://d2lang.com/

    https://github.com/terrastruct/d2/blob/master/docs/INSTALL.md

    https://github.com/terrastruct/tala#installation
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

# This shows that on Mac it'll simply install d2 via homebrew
#
#   curl -fsSL https://d2lang.com/install.sh | sh -s -- --dry-run

curl -fsSL https://d2lang.com/install.sh | sh -s --

# ==========================================
# Install proprietary Tala layout engine too
#curl -fsSL https://d2lang.com/install.sh | sh -s -- --tala
#
# belay that order, ends up with horrible:
#
#   WARNING: THIS COPY OF TALA IS UNLICENSED AND IS FOR EVALUATION PURPOSES ONLY
#
# for every run of d2 even when not using the tala layout
# ==========================================

# can also install via go but won't get the man page
#
# go install oss.terrastruct.com/d2@latest
