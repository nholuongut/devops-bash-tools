#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


# Installs CliClick on Mac OS X
#
# https://github.com/BlueM/cliclick

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VERSION="4.0.1"

if [ "$(uname -s)" != Darwin ]; then
    echo "Operating System is not Mac, cannot install MouseTools which is for Mac, aborting..."
    exit 0
fi

if type -P cliclick &>/dev/null; then
    echo "CliClick already installed"
    exit 0
fi

cd /tmp

wget -O "cliclick-$VERSION.zip" "https://github.com/BlueM/cliclick/archive/$VERSION.zip"

unzip -o "cliclick-$VERSION.zip"

cd "cliclick-$VERSION"

echo
echo "Building cliclick"
make

echo
mv -iv -- cliclick ~/bin

echo
rm -fr -- "cliclick-$VERSION" "cliclick-$VERSION.zip"

echo "cliclick is now available at ~/bin - ensure that location is in $PATH"
