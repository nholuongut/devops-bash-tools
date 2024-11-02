#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs serverless.com binary to ~/.serverless/bin/
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

if [ -n "${FORCE_INSTALL:-}" ] || ! type -P serverless &>/dev/null; then
    curl -o- -L https://slss.io/install | bash
else
    echo "serverless is already installed. To upgrade run 'serverless upgrade'"
fi

# configure by first run of:
#
#   serverless
#
# uninstall via:
#
#   serverless uninstall

echo
echo "Serverless Version:"
echo

serverless --version
