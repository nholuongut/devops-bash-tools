#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
# XXX: looks like this tool has disappeared from the website

# Installs MouseTools on Mac OS X
#
# http://www.hamsoftengineering.com/codeSnholuongutng/MouseTools/MouseTools.html

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(uname -s)" != Darwin ]; then
    echo "Operating System is not Mac, cannot install MouseTools which is for Mac, aborting..."
    exit 0
fi

if type -P MouseTools &>/dev/null; then
    echo "MouseTools already installed"
    exit 0
fi

cd /tmp

wget -O MouseTools.zip http://www.hamsoftengineering.com/assets/MouseTools.zip

unzip -o -- MouseTools.zip

mv -iv -- MouseTools ~/bin

rm -- MouseTools.zip

echo
echo "MouseTools is now available at ~/bin - ensure that location is in $PATH"
