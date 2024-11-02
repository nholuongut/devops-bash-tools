#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et



set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
#. "$srcdir/lib/utils.sh"

cd "$srcdir"

if [ -z "${APPVEYOR_TOKEN:-}" ]; then
    echo "\$APPVEYOR_TOKEN not found in environment"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

#exec docker run -ti --rm -e APPVEYOR_TOKEN -e DEBIAN_FRONTEND -v "$PWD":/pwd -w /pwd debian:9 ./appveyor_byoc.sh
#exec docker run -ti --rm -e APPVEYOR_TOKEN -e DEBIAN_FRONTEND -v "$PWD":/pwd -w /pwd nholuongut/appveyor:debian ./appveyor_byoc.sh
exec docker run -ti --rm -e APPVEYOR_TOKEN -e DEBIAN_FRONTEND nholuongut/appveyor:debian
