#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Fairwinds Nova
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

help_usage "$@"

#version="${1:-3.0.2}"
version="${1:-latest}"

export RUN_VERSION_ARG=1

"$srcdir/../github/github_install_binary.sh" FairwindsOps/nova 'nova_{version}_{os}_{arch}.tar.gz' "$version" nova
