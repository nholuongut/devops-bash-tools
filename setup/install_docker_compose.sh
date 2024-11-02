#!/usr/bin/env bash
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Docker Compose
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

#version="${1:-2.4.0}"
version="${1:-latest}"

arch="$(get_arch)"
if [ "$arch" = amd64 ]; then
    arch=x86_64
fi

export RUN_VERSION_ARG=1

"$srcdir/../github/github_install_binary.sh" docker/compose "docker-compose-{os}-$arch" "$version"
