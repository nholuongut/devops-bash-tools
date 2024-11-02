#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="Gets last build status for a DockerHub repo"

# shellcheck disable=SC2034
usage_args="<user/repo>"

if [ $# -lt 1 ]; then
    usage
fi

repo="$1"

curl -sSL "https://hub.docker.com/api/build/v1/source?image=$repo"
