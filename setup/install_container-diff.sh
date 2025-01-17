#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs container-diff to \$HOME/bin

Documentation:

    https://github.com/GoogleContainerTools/container-diff
"

help_usage "$@"

cd /tmp

if is_mac; then
    url=https://storage.googleapis.com/container-diff/latest/container-diff-darwin-amd64
else
    url=https://storage.googleapis.com/container-diff/latest/container-diff-linux-amd64
fi

wget -O container-diff "$url"

chmod +x container-diff

mkdir -pv ~/bin

mv -iv -- container-diff ~/bin
