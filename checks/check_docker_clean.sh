#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/docker.sh
. "$srcdir/lib/docker.sh"

if is_inside_docker; then
    "$srcdir/check_caches_clean.sh"
    if [ -n "$(find / -type f -name pytools_checks)" ]; then
        echo "pytools_checks detected, should have been removed from docker build"
        exit 1
    fi
fi
