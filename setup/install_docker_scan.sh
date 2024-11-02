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
Installs Docker Scan plugin to ~/.docker/cli-plugins
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

help_usage "$@"

version="${1:-latest}"

install_dir=~/.docker/cli-plugins

mkdir -p -v "$install_dir"

"$srcdir/../github/github_install_binary.sh" docker/scan-cli-plugin 'docker-scan_{os}_{arch}' "$version" "$install_dir/docker-scan"
